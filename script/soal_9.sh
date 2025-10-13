#!/bin/bash
apt-get update
apt-get install apache2 -y

mkdir -p /var/www/static.k08.com/annals

echo "<h1>Selamat datang di Arsip Lindon</h1>" > /var/www/static.k08.com/annals/index.html
echo "Catatan kuno pertama" > /var/www/static.k08.com/annals/catatan1.txt
echo "Catatan kuno kedua" > /var/www/static.k08.com/annals/catatan2.txt

chown -R www-data:www-data /var/www/static.k08.com

cat << EOF > /etc/apache2/sites-available/static.k08.com.conf
<VirtualHost *:80>
    ServerAdmin webmaster@static.k08.com
    ServerName static.k08.com
    DocumentRoot /var/www/static.k08.com

    <Directory /var/www/static.k08.com/annals>
        Options +Indexes
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/static_error.log
    CustomLog \${APACHE_LOG_DIR}/static_access.log combined
</VirtualHost>
EOF

a2ensite static.k08.com.conf
a2dissite 000-default.conf
service apache2 restart

echo "nameserver 192.215.3.2" > /etc/resolv.conf

curl -I http://static.k08.com/annals/

