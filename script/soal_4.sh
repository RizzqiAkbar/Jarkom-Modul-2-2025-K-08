#NS1 TIRION
#!/bin/bash
# ===============================================
# DNS MASTER Setup Script for domain k08.com
# Hostname : ns1 (Tirion)
# ===============================================

DOMAIN="k08.com"
ZONE_DIR="/etc/bind/zones"
ZONE_FILE="$ZONE_DIR/db.$DOMAIN"
VALMAR_IP="192.215.3.3"
TIRION_IP="192.215.3.2"
SIRION_IP="192.215.3.6"

echo "[+] Memastikan bind9 dan systemctl terinstal..."
apt update -y
apt install -y bind9 

ln -s /etc/init.d/named /etc/init.d/bind9

echo "[+] Membuat direktori zona jika belum ada..."
mkdir -p $ZONE_DIR

echo "[+] Menambahkan konfigurasi zona master ke named.conf.local..."
cat > /etc/bind/named.conf.local <<EOF
zone "$DOMAIN" {
    type master;
    file "$ZONE_FILE";
    allow-transfer { $VALMAR_IP; };
    notify yes;
};
EOF

echo "[+] Membuat file zona untuk $DOMAIN..."
cat > $ZONE_FILE <<EOF
\$TTL    604800
@       IN      SOA     ns1.$DOMAIN. root.$DOMAIN. (
                        2         ; Serial
                        604800    ; Refresh
                        86400     ; Retry
                        2419200   ; Expire
                        604800 )  ; Negative Cache TTL

; === NS Records ===
@       IN      NS      ns1.$DOMAIN.
@       IN      NS      ns2.$DOMAIN.

; === A Records ===
ns1     IN      A       $TIRION_IP
ns2     IN      A       $VALMAR_IP
@       IN      A       $SIRION_IP
EOF

echo "[+] Mengatur forwarders di named.conf.options..."
cat > /etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    recursion yes;
};
EOF

echo "[+] Mengecek konfigurasi bind..."
named-checkconf
named-checkzone $DOMAIN $ZONE_FILE

echo "[+] Mengaktifkan dan merestart layanan bind9..."
service bind9 restart

echo "[+] Setup DNS master untuk $DOMAIN selesai!"


#NS2 VALMAR
#!/bin/bash
# ===============================================
# DNS SLAVE Setup Script for domain k08.com
# Hostname : ns2 (Valmar)
# ===============================================

DOMAIN="k08.com"
TIRION_IP="192.215.3.2"
ZONE_FILE="/var/lib/bind/db.$DOMAIN"

echo "[+] Memastikan bind9 dan systemctl terinstal..."
apt update -y
apt install -y bind9 

ln -s /etc/init.d/named /etc/init.d/bind9

echo "[+] Menambahkan konfigurasi zona slave ke named.conf.local..."
cat > /etc/bind/named.conf.local <<EOF
zone "$DOMAIN" {
    type slave;
    masters { $TIRION_IP; };
    file "$ZONE_FILE";
};
EOF

echo "[+] Mengatur forwarders di named.conf.options..."
cat > /etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    recursion yes;
};
EOF

echo "[+] Mengecek konfigurasi bind..."
named-checkconf

echo "[+] Mengaktifkan dan merestart layanan bind9..."
service bind9 restart

echo "[+] Setup DNS slave untuk $DOMAIN selesai!"
