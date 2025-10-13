# -------------- TIRION ---------
#!/bin/bash
echo "[+] Konfigurasi Reverse Zone di Tirion (ns1)"

apt-get update -y >/dev/null 2>&1
apt-get install -y bind9 bind9-utils bind9-dnsutils >/dev/null 2>&1

ZONE_DIR="/etc/bind/rev"
ZONE_FILE="$ZONE_DIR/3.215.192.in-addr.arpa"

mkdir -p $ZONE_DIR

if ! grep -q "3.215.192.in-addr.arpa" /etc/bind/named.conf.local; then
cat <<EOF >> /etc/bind/named.conf.local

zone "3.215.192.in-addr.arpa" {
    type master;
    file "/etc/bind/rev/3.215.192.in-addr.arpa";
    also-notify { 192.215.3.3; };
    allow-transfer { 192.215.3.3; };
};
EOF
echo "[+] Zona reverse ditambahkan ke named.conf.local"
else
echo "[!] Zona reverse sudah ada di konfigurasi"
fi

# Tulis isi zona reverse
cat <<EOF > $ZONE_FILE
\$TTL 604800
@   IN  SOA ns1.k08.com. root.k08.com. (
        2025101101 ; Serial
        604800      ; Refresh
        86400       ; Retry
        2419200     ; Expire
        604800 )    ; Negative Cache TTL

; Name Server
@   IN  NS  ns1.k08.com.
@   IN  NS  ns2.k08.com.

; PTR Records
4   IN  PTR lindon.k08.com.
5   IN  PTR vingilot.k08.com.
6   IN  PTR sirion.k08.com.
EOF

named-checkzone 3.215.192.in-addr.arpa $ZONE_FILE
named-checkconf

echo "[+] Restarting BIND..."
service bind9 restart

echo "[OK] Reverse zone berhasil dibuat di Tirion (Master)"

# -------------------- VALMAR ---------------------
#!/bin/bash
echo "[+] Konfigurasi Reverse Zone di Valmar (ns2)"

# Pastikan BIND terinstal
apt-get update -y >/dev/null 2>&1
apt-get install -y bind9 bind9-utils bind9-dnsutils >/dev/null 2>&1

# Tambahkan konfigurasi zona ke named.conf.local
if ! grep -q "3.215.192.in-addr.arpa" /etc/bind/named.conf.local; then
cat <<EOF >> /etc/bind/named.conf.local

zone "3.215.192.in-addr.arpa" {
    type slave;
    masters { 192.215.3.2; };
    file "/var/lib/bind/3.215.192.in-addr.arpa";
};
EOF
echo "[+] Zona reverse slave ditambahkan ke named.conf.local"
else
echo "[!] Zona reverse slave sudah ada di konfigurasi"
fi

echo "[+] Restarting BIND..."
service bind9 restart

sleep 3

if [ -f /var/lib/bind/3.215.192.in-addr.arpa ]; then
    echo "[OK] Zone file tersinkron dari master."
else
    echo "[!] Zone file belum tersinkron. Pastikan Tirion (ns1) sudah aktif dan mengizinkan transfer."
fi
