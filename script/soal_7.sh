#!/bin/bash
# ------- TIRION -----------

echo "[+] Menambahkan record web ke zona k08.com (ns1 - Tirion)"

apt update -qq
apt install -y bind9 bind9-utils bind9-dnsutils >/dev/null

ZONEDIR="/etc/bind/zones"
ZONEFILE="$ZONEDIR/k08.com"

mkdir -p $ZONEDIR

echo "[+] Menulis ulang file zona..."
cat > $ZONEFILE <<'EOF'
$TTL    604800
@       IN      SOA     ns1.k08.com. root.k08.com. (
                        2025101116  ; Serial
                        604800      ; Refresh
                        86400       ; Retry
                        2419200     ; Expire
                        604800 )    ; Negative Cache TTL

; Name Servers
@       IN      NS      ns1.k08.com.
@       IN      NS      ns2.k08.com.

; Address Records
ns1     IN      A       192.215.3.2
ns2     IN      A       192.215.3.3

; Switch 1 (192.215.1.x)
earendil    IN  A   192.215.1.2
elwing      IN  A   192.215.1.3

; Switch 2 (192.215.2.x)
cildan      IN  A   192.215.2.2
elrond      IN  A   192.215.2.3
maglor      IN  A   192.215.2.4

; Switch 3–4 (192.215.3.x)
tirion      IN  A   192.215.3.2
valmar      IN  A   192.215.3.3
lindon      IN  A   192.215.3.4
vingilot    IN  A   192.215.3.5
sirion      IN  A   192.215.3.6

; Web records
sirion      IN  A   192.215.3.6
lindon      IN  A   192.215.3.4
vingilot    IN  A   192.215.3.5

; CNAME aliases
www         IN  CNAME   sirion.k08.com.
static      IN  CNAME   lindon.k08.com.
app         IN  CNAME   vingilot.k08.com.
EOF

echo "[+] Mengecek konfigurasi zona..."
named-checkzone k08.com $ZONEFILE

echo "[+] Restarting bind9..."
service bind9 restart

echo "[OK] Zona berhasil diperbarui di ns1 (Tirion)"

#!/bin/bash
# ------- VALMAR -------------

echo "[+] Menyiapkan ns2 (Valmar) agar menerima update zona dari ns1..."

apt update -qq
apt install -y bind9 bind9-utils bind9-dnsutils >/dev/null

service bind9 restart

echo "[+] Menunggu beberapa detik untuk zone transfer..."
sleep 5

ZONEFILE="/var/lib/bind/db.k08.com"

if [ -f "$ZONEFILE" ]; then
    echo "[OK] Zone file ditemukan di $ZONEFILE"
else
    echo "[!] Zone file belum tersalin. Pastikan allow-transfer di ns1 mengizinkan ns2."
    exit 1
fi

echo
echo "[+] Mengecek serial SOA master dan slave:"
dig @192.215.3.2 k08.com SOA +short
dig @192.215.3.3 k08.com SOA +short

echo
echo "[OK] Sinkronisasi zona selesai di ns2 (Valmar)"
