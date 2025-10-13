# ---- TIRION ----
#!/bin/bash
echo "[+] Setup DNS Master (Tirion - ns1) untuk k08.com"

apt update
apt install -y bind9 bind9utils bind9-doc dnsutils

mkdir -p /etc/bind/zones

echo "[+] Menambahkan konfigurasi zona master ke /etc/bind/named.conf.local..."
cat > /etc/bind/named.conf.local <<EOF
zone "k08.com" {
    type master;
    file "/etc/bind/zones/k08.com";
    allow-transfer { 192.215.3.3; }; // Valmar (ns2)
    also-notify { 192.215.3.3; };
};
EOF

echo "[+] Membuat file zona k08.com..."
cat > /etc/bind/zones/k08.com <<EOF
\$TTL    604800
@       IN      SOA     ns1.k08.com. root.k08.com. (
                        2025101101      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@       IN      NS      ns1.k08.com.
@       IN      NS      ns2.k08.com.

ns1     IN      A       192.215.3.2
ns2     IN      A       192.215.3.3

earendil    IN  A       192.215.1.2
elwing      IN  A       192.215.1.3
cildan      IN  A       192.215.2.2
elrond      IN  A       192.215.2.3
maglor      IN  A       192.215.2.4
tirion      IN  A       192.215.3.2
valmar      IN  A       192.215.3.3
lindon      IN  A       192.215.3.4
vingilot    IN  A       192.215.3.5
sirion      IN  A       192.215.3.6
EOF

echo "[+] Mengatur forwarders global..."
cat > /etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-query { any; };
    forwarders {
        8.8.8.8;
        1.1.1.1;
    };
    dnssec-validation no;
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF

echo "[+] Restarting Bind9..."
service bind9 restart

echo "[+] Cek konfigurasi..."
named-checkconf
named-checkzone k08.com /etc/bind/zones/k08.com

echo "[+] DNS Master Tirion selesai disiapkan!"

# --- VALMAR ----
#!/bin/bash
echo "[+] Setup DNS Slave (Valmar - ns2) untuk k08.com"

apt update
apt install -y bind9 bind9utils dnsutils

echo "[+] Menambahkan konfigurasi zona slave ke /etc/bind/named.conf.local..."
cat > /etc/bind/named.conf.local <<EOF
zone "k08.com" {
    type slave;
    masters { 192.215.3.2; }; // Tirion (ns1)
    file "/var/lib/bind/db.k08.com";
};
EOF

echo "[+] Mengatur forwarders global..."
cat > /etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-query { any; };
    forwarders {
        8.8.8.8;
        1.1.1.1;
    };
    dnssec-validation no;
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF

echo "[+] Restarting Bind9..."
service bind9 restart

echo "[+] Mengecek apakah zona tersalin..."
sleep 5
ls -l /var/lib/bind/ | grep k08.com && echo "[OK] Zone file ditemukan (zone transfer sukses)" || echo "[!] Zone file belum tersalin"

echo "[+] Mengecek serial SOA dari master dan slave..."
dig @192.215.3.2 k08.com SOA +short
dig @192.215.3.3 k08.com SOA +short

echo "[+] DNS Slave Valmar selesai disiapkan!"
