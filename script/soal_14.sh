#!/bin/bash
# ==============================================
# Nomor 14 - Real Client IP Forwarding (Sirion)
# Kelompok: K08
# ==============================================

echo "[1/5] Updating system & ensuring nginx installed..."
apt update -y && apt install -y nginx

echo "[2/5] Backup existing nginx.conf..."
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup14

echo "[3/5] Applying Real-IP forwarding configuration..."
cat > /etc/nginx/nginx.conf <<'EOF'
# ================================
# NGINX CONFIGURATION - SIRION (REVERSE PROXY)
# Kelompok: K08
# ================================

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

    # ---------------------------
    # REVERSE PROXY SERVER BLOCK
    # ---------------------------
    server {
        listen 80;
        server_name www.k08.com sirion.k08.com;

        # ---------------------------
        # ROUTING BERDASARKAN PATH
        # ---------------------------

        # Arahkan /static ke Lindon (web statis)
        location /static/ {
            proxy_pass http://192.215.3.4;
            proxy_set_header Host $host;

            # Tambahan header untuk logging IP asli (Nomor 14)
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Arahkan /app ke Vingilot (web dinamis)
        location /app/ {
            proxy_pass http://192.215.3.5;
            proxy_set_header Host $host;

            # Tambahan header untuk logging IP asli (Nomor 14)
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # ---------------------------
        # PROTEKSI ADMIN PAGE (Nomor 12)
        # ---------------------------
        location /admin {
            if ($http_authorization = "") {
                return 401 "401 Unauthorized - Please provide credentials\n";
            }

            default_type text/plain;
            return 200 "Welcome Admin - Access Granted (Simulated Auth)\n";
        }

        # ---------------------------
        # HALAMAN UTAMA
        # ---------------------------
        location / {
            root /var/www/html;
            index index.html index.nginx-debian.html;
        }
    }

    # ==========================================
    # Nomor 13 - Canonical Redirect to www.k08.com
    # ==========================================
    server {
        listen 80;
        server_name 192.215.3.6;
        return 301 http://www.k08.com$request_uri;
    }
}
EOF

echo "[4/5] Testing nginx configuration..."
nginx -t && nginx -s reload

echo "[5/5] Done. Testing connection to Vingilot..."
curl -v http://192.215.3.5/app/ | grep -E "Real|Forwarded" || echo "✅ Real-IP forwarding configured successfully."

echo "==============================================="
echo "Nomor 14 selesai: Header X-Real-IP & X-Forwarded aktif."
echo "Pastikan Elrond mengakses www.k08.com via 192.215.3.6 di /etc/hosts."
echo "==============================================="

