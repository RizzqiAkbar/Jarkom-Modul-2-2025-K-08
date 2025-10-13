#!/bin/bash
# ==========================================
# K08 - Nomor 18: Tambah record Melkor & Morgoth
# ==========================================
ZONE_FILE="/etc/bind/db.k08.com"
echo "🧠 Menambahkan record Melkor & Morgoth ke zona k08.com ..."

# Backup
cp $ZONE_FILE ${ZONE_FILE}.bak_$(date +%s)

# Tambahkan record baru
cat <<'EOF' >> $ZONE_FILE
melkor      IN      TXT     "Morgoth (Melkor)"
morgoth     IN      CNAME   melkor.k08.com.
EOF

# Naikkan serial otomatis (+1)
sed -i -E 's/([0-9]{10,})/\1 + 1/e' $ZONE_FILE

# Validasi & reload bind
named-checkzone k08.com $ZONE_FILE
killall named 2>/dev/null
named -c /etc/bind/named.conf -f > /var/log/named.log 2>&1 &

# Tes hasil
echo "✅ Record berhasil ditambahkan. Tes query:"
dig melkor.k08.com TXT @192.215.3.2 +short
dig morgoth.k08.com TXT @192.215.3.2 +short

