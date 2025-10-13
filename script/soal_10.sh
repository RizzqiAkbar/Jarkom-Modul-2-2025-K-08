#!/bin/bash
# Hostname: app.k08.com
# IP: 192.215.3.5

set -e

echo "[+] Menginstal Apache + PHP-FPM..."
apt-get update -y
apt-get install -y apache2 php php-fpm libapache2-mod-fcgid

echo "[+] Mendeteksi versi PHP-FPM..."
PHP_VERSION=$(php -v | head -n1 | awk '{print $2}' | cut -d'.' -f1,2)
PHP_FPM_SERVICE="php${PHP_VERSION}-fpm"
PHP_SOCKET="/run/php/${PHP_FPM_SERVICE}.sock"

echo "[+] Versi PHP-FPM terdeteksi: $PHP_VERSION"
echo "[+] Socket PHP-FPM: $PHP_SOCKET"

echo "[+] Mengaktifkan module Apache..."
a2enmod proxy_fcgi setenvif rewrite
a2enconf ${PHP_FPM_SERVICE} 2>/dev/null || true

echo "[+] Membuat direktori web..."
mkdir -p /var/www/app.k08.com

echo "[+] Membuat file index.php dan about.php..."
cat > /var/www/app.k08.com/index.php << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Vingilot - Home</title></head>
<body>
<h1>Selamat datang di Vingilot!</h1>
<p>Ini adalah halaman beranda dari web dinamis.</p>
<p><a href="/about">Tentang Kami</a></p>
</body>
</html>
EOF

cat > /var/www/app.k08.com/about.php << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Tentang Vingilot</title></head>
<body>
<h1>Halaman About</h1>
<p>Ini adalah halaman tentang Vingilot, kapal yang membawa cerita dinamis.</p>
<p><a href="/">Kembali ke beranda</a></p>
</body>
</html>
EOF

echo "[+] Membuat konfigurasi VirtualHost..."
cat > /etc/apache2/sites-available/app.k08.com.conf << EOF
<VirtualHost *:80>
    ServerName app.k08.com
    DocumentRoot /var/www/app.k08.com

    <Directory /var/www/app.k08.com>
        Options +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:${PHP_SOCKET}|fcgi://localhost/"
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/app-error.log
    CustomLog \${APACHE_LOG_DIR}/app-access.log combined
</VirtualHost>
EOF

echo "[+] Menambahkan aturan rewrite (.htaccess)..."
cat > /var/www/app.k08.com/.htaccess << 'EOF'
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^about$ about.php [L]
EOF

echo "[+] Mengaktifkan VirtualHost..."
a2ensite app.k08.com.conf

echo "[+] Memastikan PHP-FPM aktif..."
if service --status-all 2>&1 | grep -q "${PHP_FPM_SERVICE}"; then
    service $PHP_FPM_SERVICE enable 2>/dev/null || true
    service $PHP_FPM_SERVICE restart
else
    echo "[-] PHP-FPM service $PHP_FPM_SERVICE tidak ditemukan. Jalankan manual."
fi

echo "[+] Restart Apache..."
if service --status-all 2>&1 | grep -q "apache2"; then
    service apache2 restart
else
    echo "[-] Apache2 tidak ditemukan. Jalankan manual."
fi

echo "[OK] Web dinamis Vingilot aktif di http://app.k08.com/"

