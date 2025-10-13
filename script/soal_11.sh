#!/bin/bash
# ============================================
# SIRION - Reverse Proxy Path-based Routing
# ============================================

echo "[+] Konfigurasi /etc/hosts..."
cat <<EOF > /etc/hosts
127.0.0.1       localhost
192.215.3.6     www.K08.com sirion.K08.com
192.215.3.4     lindon.K08.com
192.215.3.5     vingilot.K08.com
EOF

echo "[+] Membuat konfigurasi nginx.conf..."
cat <<'EOF' > /etc/nginx/nginx.conf
user  www-data;
worker_processes  auto;

events {
    worker_connections 1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile on;
    keepalive_timeout 65;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    server {
        listen 80;
        server_name www.K08.com sirion.K08.com;

        location /static/ {
            proxy_pass http://192.215.3.4;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /app/ {
            proxy_pass http://192.215.3.5;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location / {
            root /var/www/html;
            index index.html;
        }
    }
}
EOF

echo "[+] Restart nginx..."
killall nginx 2>/dev/null
nginx -t && nginx

echo "[+] Tes koneksi..."
curl -I http://www.K08.com/app/
curl -I http://www.K08.com/static/

#!/bin/bash
# ============================================
# LINDON - Backend untuk /static
# ============================================

echo "[+] Membuat direktori dan file konten..."
mkdir -p /var/www/html/static
echo "Halo dari Lindon (backend /static)" > /var/www/html/static/index.html

echo "[+] Membuat konfigurasi nginx..."
cat <<'EOF' > /etc/nginx/sites-enabled/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /static/ {
        alias /var/www/html/static/;
        index index.html;
    }
}
EOF

echo "[+] Restart nginx..."
killall nginx 2>/dev/null
nginx -t && nginx

echo "[+] Tes lokal..."
curl http://localhost/static/

Vingilot : 
#!/bin/bash
# ============================================
# VINGILOT - Backend untuk /app
# ============================================

echo "[+] Membuat direktori dan file konten..."
mkdir -p /var/www/html/app
echo "Halo dari Vingilot (backend /app)" > /var/www/html/app/index.html

echo "[+] Membuat konfigurasi nginx..."
cat <<'EOF' > /etc/nginx/sites-enabled/default
server {
    listen 80 default_server;
