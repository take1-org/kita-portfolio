#!/usr/bin/env bash
set -Eeuo pipefail

# =========================
# Vars (override via ENV)
# =========================
: "${APP_DOCROOT:=/var/www/html}"
: "${PHP_FPM_RUN_DIR:=/run/php-fpm}"
: "${PHP_FPM_SOCK:=${PHP_FPM_RUN_DIR}/php-fpm.sock}"
: "${PHP_FPM_SOCK_MODE:=0666}"
: "${PHP_FPM_SOCK_USER:=www-data}"
: "${PHP_FPM_SOCK_GROUP:=www-data}"
: "${APP_PUBLIC_URL:=https://woocommerce.take-one.link}"  # ← 追加（環境変数で上書き可）

# =========================
# 1) WP コア配置（wp-contentは除外）
# =========================
mkdir -p "${APP_DOCROOT}"

if [ ! -f "${APP_DOCROOT}/index.php" ]; then
  echo "[init] Syncing WordPress core into ${APP_DOCROOT} (excluding wp-content) ..."
  set +e
  rsync -rltD --delete \
        --no-owner --no-group --no-perms --omit-dir-times \
        --exclude 'wp-content/*' \
        /usr/src/wordpress/ "${APP_DOCROOT}/"
  RSYNC_RC=$?
  set -e
  # EFS がらみで属性変更ができず 23(partial) になるのは許容
  if [ "$RSYNC_RC" -ne 0 ] && [ "$RSYNC_RC" -ne 23 ]; then
    echo "[fatal] rsync failed with code ${RSYNC_RC}"; exit "$RSYNC_RC"
  else
    echo "[init] rsync completed with code ${RSYNC_RC} (treated as OK)"
  fi
fi

# wp-content は EFS に任せる（存在しなければ作成だけ）
mkdir -p "${APP_DOCROOT}/wp-content" || true

# =========================
# ★ wp-config.php 自動生成処理（追加）
# =========================
if [ ! -f "${APP_DOCROOT}/wp-config.php" ]; then
  echo "[init] Generating wp-config.php ..."
  SRC="${APP_DOCROOT}/wp-config-sample.php"
  [ -f "$SRC" ] || SRC="/usr/src/wordpress/wp-config-sample.php"
  cp "$SRC" "${APP_DOCROOT}/wp-config.php"

  cat <<'PHP' >> "${APP_DOCROOT}/wp-config.php"

/** take-one custom: enforce HTTPS behind CloudFront/ALB **/
if (
  (!empty($_SERVER['HTTP_CLOUDFRONT_FORWARDED_PROTO']) && $_SERVER['HTTP_CLOUDFRONT_FORWARDED_PROTO'] === 'https') ||
  (!empty($_SERVER['HTTP_X_FORWARDED_PROTO']) && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
) {
  $_SERVER['HTTPS'] = 'on';
  $_SERVER['SERVER_PORT'] = 443;
}
PHP

  echo "define('WP_HOME',    '${APP_PUBLIC_URL}');"  >> "${APP_DOCROOT}/wp-config.php"
  echo "define('WP_SITEURL', '${APP_PUBLIC_URL}');"  >> "${APP_DOCROOT}/wp-config.php"
  chmod 640 "${APP_DOCROOT}/wp-config.php" || true
fi

# =========================
# コアのみ権限最適化（wp-content は一切触らない）
# =========================
chown -R www-data:www-data "${APP_DOCROOT}" || true
find "${APP_DOCROOT}" -path "${APP_DOCROOT}/wp-content" -prune -o -type d -exec chmod 755 {} \; || true
find "${APP_DOCROOT}" -path "${APP_DOCROOT}/wp-content" -prune -o -type f -exec chmod 644 {} \; || true

# =========================
# 2) PHP-FPM ソケット準備（/run はエフェメラル）
# =========================
mkdir -p "${PHP_FPM_RUN_DIR}"
chown -R "${PHP_FPM_SOCK_USER}:${PHP_FPM_SOCK_GROUP}" "${PHP_FPM_RUN_DIR}" || true
chmod 0775 "${PHP_FPM_RUN_DIR}" || true
if [ -S "${PHP_FPM_SOCK}" ]; then
  echo "[init] Removing stale socket: ${PHP_FPM_SOCK}"
  rm -f "${PHP_FPM_SOCK}"
fi

# =========================
# 3) プール設定をソケット化（パッチ or フォールバック）
# =========================
PATCHED=0
conf_candidates=(
  "/usr/local/etc/php-fpm.d/www.conf"
  "/usr/local/etc/php-fpm.conf"
  "/etc/php/*/fpm/pool.d/www.conf"
  "/etc/php-fpm.d/www.conf"
)
for path in "${conf_candidates[@]}"; do
  for f in $(ls -1d ${path} 2>/dev/null || true); do
    if [ -f "$f" ]; then
      echo "[init] Patching PHP-FPM config: $f"
      sed -ri "s|^[;[:space:]]*listen\s*=.*$|listen = ${PHP_FPM_SOCK}|g" "$f" || true
      grep -q '^;?listen.owner' "$f" && sed -ri "s|^;?listen.owner\s*=.*$|listen.owner = ${PHP_FPM_SOCK_USER}|g" "$f" || echo "listen.owner = ${PHP_FPM_SOCK_USER}" >> "$f"
      grep -q '^;?listen.group' "$f" && sed -ri "s|^;?listen.group\s*=.*$|listen.group = ${PHP_FPM_SOCK_GROUP}|g" "$f" || echo "listen.group = ${PHP_FPM_SOCK_GROUP}" >> "$f"
      grep -q '^;?listen.mode'  "$f" && sed -ri "s|^;?listen.mode\s*=.*$|listen.mode = ${PHP_FPM_SOCK_MODE}|g" "$f" || echo "listen.mode = ${PHP_FPM_SOCK_MODE}" >> "$f"
      grep -q '^;?clear_env'    "$f" && sed -ri "s|^;?clear_env\s*=.*$|clear_env = no|g" "$f" || echo "clear_env = no" >> "$f"
      PATCHED=1
    fi
  done
done

# 見つからなかったらフォールバック（必ずソケット待受にする）
if [ "$PATCHED" -eq 0 ]; then
  echo "[warn] No existing pool conf patched. Writing fallback /usr/local/etc/php-fpm.d/zz-socket.conf"
  mkdir -p /usr/local/etc/php-fpm.d
  cat > /usr/local/etc/php-fpm.d/zz-socket.conf <<CONF
[www]
user = ${PHP_FPM_SOCK_USER}
group = ${PHP_FPM_SOCK_GROUP}

listen = ${PHP_FPM_SOCK}
listen.owner = ${PHP_FPM_SOCK_USER}
listen.group = ${PHP_FPM_SOCK_GROUP}
listen.mode  = ${PHP_FPM_SOCK_MODE}

pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 5

clear_env = no
CONF
fi

# 構文チェック（失敗時は起動しないで終了）
if command -v php-fpm >/dev/null 2>&1; then
  php-fpm -tt || { echo "[fatal] php-fpm config test failed"; exit 1; }
fi

# =========================
# 4) php-fpm をFG起動（CMD/command で指定想定: php-fpm -F）
# =========================
echo "[init] Starting PHP-FPM (socket: ${PHP_FPM_SOCK}) ..."
exec "$@"
