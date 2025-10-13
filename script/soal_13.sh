#!/bin/bash
# ===========================================
# Setup Canonical Redirect (Nomor 13)
# Modul 2 - Komdat Jarkom 2025
# Server: Sirion (Reverse Proxy)
# Kelompok: K08
# ===========================================

echo "=== [1/6] Updating package list..."
apt update -y

echo "=== [2/6] Installing nginx if not installed..."
apt install -y nginx

echo "=== [3/6] Backing up current nginx.conf..."
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup_redirect

echo "=== [4/6] Adding canonical redirect server block..."
# Hapus blok lama jika ada dan tambahkan blok baru
grep -q "Canonical Redirect" /etc/nginx/nginx.conf || cat >> /etc/nginx/nginx.conf <<'EOF'

    # ==========================================
    # Nomor 13 - Canonical Redirect to www.k08.com
    # ==========================================
    server {
        listen 80;
        server_name 192.215.3.6;

        return 301 http://www.k08.com$request_uri;
    }
EOF

echo "=== [5/6] Creating homepage and fixing permissions..."
mkdir -p /var/www/html
echo "<h1>War of Wrath: Lindon bertahan</h1><p><a href='/app'>/app</a> | <a href='/static'>/static</a></p>" > /var/www/html/index.html
chmod -R 755 /var/www/html
chown -R www-data:www-data /var/www/html

echo "=== [6/6] Testing and reloading nginx..."
nginx -t && nginx -s reload

echo
echo "=== Canonical Redirect Setup Complete! ==="
echo "Try testing with:"
echo "  -> curl -I http://192.215.3.6        # Should redirect (301) to www.k08.com"
echo "  -> curl -I http://sirion.k08.com     # Should return 200 OK"
echo "  -> curl -I http://www.k08.com        # Should return 200 OK"

