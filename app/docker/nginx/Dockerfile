FROM nginx:1.28-alpine

# ユーティリティ（ヘルスチェック等で使用）
RUN apk add --no-cache bash curl

# 設定ファイルを配置
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf

# ドキュメントルート（EFS マウント予定）
WORKDIR /var/www/html
RUN mkdir -p /var/www/html && chown -R nginx:nginx /var/www/html

# 80 番で待ち受け（root のままで OK。worker は nginx に降格）
EXPOSE 80
CMD ["nginx","-g","daemon off;"]