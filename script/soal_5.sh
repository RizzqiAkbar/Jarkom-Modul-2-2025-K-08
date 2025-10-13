# ----- TIRION.sh -----
# !/bin/bash
echo "[+] Setup DNS Master (ns1 - Tirion) untuk k08.com..."

apt update -y
apt install bind9 bind9utils bind9-doc -y

mkdir -p /etc/bind/zones

cat > /etc/bind/named.conf.local << 'EOF'
zone "k08.com" {
    type master;
    file "/etc/bind/zones/db.k08.com";
    allow-transfer { 192.215.3.3; }; // Valmar (ns2)
    notify yes;
};
EOF

cat > /etc/bind/zones/db.k08.com << 'EOF'
$TTL 604800
@   IN  SOA ns1.k08.com. root.k08.com. (
        2025101101 ; Serial
        604800     ; Refresh
        86400      ; Retry
        2419200    ; Expire
        604800 )   ; Negative Cache TTL
;
@       IN  NS      ns1.k08.com.
@       IN  NS      ns2.k08.com.

; --- Server DNS ---
ns1     IN  A       192.215.3.2
ns2     IN  A       192.215.3.3

; --- Switch1 subnet ---
earendil IN A       192.215.1.2
elwing   IN A       192.215.1.3

; --- Switch2 subnet ---
cildan  IN  A       192.215.2.2
elrond  IN  A       192.215.2.3
maglor  IN  A       192.215.2.4

; --- Switch3+4 subnet ---
tirion  IN  A       192.215.3.2
valmar  IN  A       192.215.3.3
lindon  IN  A       192.215.3.4
vingilot IN A       192.215.3.5
sirion  IN  A       192.215.3.6

; Apex domain mengarah ke front door
@       IN  A       192.215.3.6
EOF

cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-query { any; };
    forwarders { 192.168.122.1; };
    dnssec-validation no;
    listen-on { any; };
    listen-on-v6 { none; };
};
EOF

named-checkconf
named-checkzone k08.com /etc/bind/zones/db.k08.com

service bind9 restart || /usr/sbin/named -c /etc/bind/named.conf -g &
echo "[✓] DNS Master (Tirion) untuk k08.com selesai disetup!"


# ----- VALMAR.sh -----
#!/bin/bash
echo "[+] Setup DNS Slave (ns2 - Valmar) untuk k08.com..."

apt update -y
apt install bind9 bind9utils bind9-doc -y

cat > /etc/bind/named.conf.local << 'EOF'
zone "k08.com" {
    type slave;
    masters { 192.215.3.2; }; // Tirion (ns1)
    file "/var/lib/bind/db.k08.com";
};
EOF

cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-query { any; };
    forwarders { 192.168.122.1; };
    dnssec-validation no;
    listen-on { any; };
    listen-on-v6 { none; };
};
EOF

service bind9 restart || /usr/sbin/named -c /etc/bind/named.conf -g &
echo "[✓] DNS Slave (Valmar) untuk k08.com selesai disetup!"
