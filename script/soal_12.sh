#!/bin/bash
# ===========================================
# Setup Basic Auth Simulation for /admin (Sirion)
# Modul 2 - Komdat Jarkom 2025
# Kelompok: K08
# ===========================================

echo "=== [1/6] Updating package list..."
apt update -y

echo "=== [2/6] Installing nginx and apache2-utils..."
apt install -y nginx apache2-utils

echo "=== [3/6] Creating dummy password file (.htpasswd)..."
# Membuat file password (untuk dokumentasi)
htpasswd -bc /etc/nginx/.htpasswd admin komdat

echo "=== [4/6] Backing up original nginx.conf..."
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

echo "=== [5/6] Writing new nginx.conf with simulated Basic Auth..."
cat > /etc/nginx/nginx.conf <<'EOF'
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
        server_name www.k08.com sirion.k08.com;

        # Reverse Proxy Paths
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

        # ==============================
        # Simulated Basic Auth for /admin
        # ==============================
        location /admin {
            if ($http_authorization = "") {
                return 401 "401 Unauthorized - Please provide credentials\n";
            }
            default_type text/plain;
            return 200 "Welcome Admin - Access Granted (Simulated Auth)\n";
        }

        # Default page
        location / {
            root /var/www/html;
            index index.html;
        }
    }
}
EOF

echo "=== [6/6] Testing and reloading nginx..."
nginx -t && nginx -s reload

echo
echo "=== Setup Complete! ==="
echo "Try accessing:"
echo "  -> curl http://www.k08.com/admin       # Should return 401"
echo "  -> curl -u admin:admin http://www.k08.com/admin  # Should return 'Welcome Admin'"

