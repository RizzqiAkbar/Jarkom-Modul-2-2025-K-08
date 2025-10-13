#!/bin/bash
# ================================================
# Nomor 20 - War of Wrath: Lindon Bertahan
# Kelompok K08
# ================================================

echo "=== Membuat halaman beranda di /var/www/html ==="
mkdir -p /var/www/html
cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>War of Wrath: Lindon bertahan</title>
</head>
<body style="background-color:#0b132b; color:white; font-family:Arial; text-align:center; margin-top:10%;">
  <h1>⚔️ War of Wrath: Lindon bertahan ⚔️</h1>
  <p>Selamat datang di beranda kelompok K08</p>
  <p><a href="http://www.k08.com/app" style="color:#03A9F4;">Masuk ke App</a></p>
  <p><a href="http://www.k08.com/static" style="color:#F9A825;">Lihat Static Files</a></p>
</body>
</html>
EOF

echo "=== Konfigurasi Virtual Host Nginx ==="
cat > /etc/nginx/sites-available/www.k08.com <<'EOF'
server {
    listen 80;
    server_name www.k08.com;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /app {
        proxy_pass http://192.215.3.5;
    }

    location /static {
        proxy_pass http://192.215.2.3;
    }
}
EOF

ln -sf /etc/nginx/sites-available/www.k08.com /etc/nginx/sites-enabled/www.k08.com

echo "=== Reload Nginx tanpa systemctl ==="
nginx -t && nginx -s reload

echo "=== Verifikasi koneksi ==="
curl -I http://www.k08.com
curl -I http://www.k08.com/app
curl -I http://www.k08.com/static

echo "=== Nomor 20 selesai: Halaman utama aktif di www.k08.com ==="

