# WordPress/WooCommerce 用 PHP-FPM 8.4
FROM php:8.4-fpm-bookworm

# 必要パッケージと PHP 拡張
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    libjpeg62-turbo-dev libpng-dev libfreetype6-dev \
    libzip-dev libicu-dev \
    libmagickwand-dev pkg-config \
    unzip rsync git curl ca-certificates \
    libfcgi-bin \
  ; \
  docker-php-ext-configure gd --with-freetype --with-jpeg; \
  docker-php-ext-install -j"$(nproc)" gd zip intl exif bcmath mysqli pdo_mysql opcache; \
  pecl install redis imagick; docker-php-ext-enable redis imagick; \
  rm -rf /var/lib/apt/lists/*

# 運用向けの基本設定
RUN set -eux; \
  { \
    echo 'memory_limit=512M'; \
    echo 'upload_max_filesize=128M'; \
    echo 'post_max_size=128M'; \
    echo 'max_execution_time=180'; \
    echo 'opcache.enable=1'; \
  } > /usr/local/etc/php/conf.d/wp.ini

# FastCGI ping/status（任意）
RUN set -eux; \
  { \
    echo 'ping.path = /ping'; \
    echo 'ping.response = pong'; \
    echo 'pm.status_path = /status'; \
  } > /usr/local/etc/php-fpm.d/zz-ping.conf

# ★ PHP-FPM をソケット待受けに固定（wwwプール）
RUN set -eux; \
  mkdir -p /usr/local/etc/php-fpm.d; \
  cat > /usr/local/etc/php-fpm.d/zz-socket.conf <<'CONF'
[www]
user = www-data
group = www-data

listen = /run/php-fpm/php-fpm.sock
listen.owner = www-data
listen.group = www-data
listen.mode  = 0666

pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 5

clear_env = no
CONF

# wp-cli
RUN curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x /usr/local/bin/wp

# WordPress 本体（最新版を同梱。起動時に wp_root へ同期）
ENV WP_VERSION=6.8.3
RUN set -eux; \
  curl -fsSL -o /tmp/wp.tgz https://wordpress.org/wordpress-${WP_VERSION}.tar.gz; \
  tar -xf /tmp/wp.tgz -C /usr/src/; rm /tmp/wp.tgz; \
  mkdir -p /var/www/html; \
  rsync -a /usr/src/wordpress/ /var/www/html/; \
  chown -R www-data:www-data /var/www/html

# entrypoint スクリプト
COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html
# EXPOSE 9000  # ソケット運用のため任意

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm", "-F"]
