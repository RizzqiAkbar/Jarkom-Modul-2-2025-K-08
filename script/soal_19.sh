#!/bin/bash
# ==========================================
# Konfigurasi Nomor 19 - DNS CNAME havens.k08.com → www.k08.com
# Kelompok: K08
# ==========================================

echo "=== [1] Update zona di Tirion (Master DNS) ==="
ZONE_FILE="/etc/bind/db.k08.com"

# Pastikan file zona ada
if [ -f "$ZONE_FILE" ]; then
    # Ubah record www agar mengarah ke IP Sirion (192.215.3.6)
    sed -i 's/^\(www[[:space:]]\+IN[[:space:]]\+A[[:space:]]\+\).*/\1192.215.3.6/' "$ZONE_FILE"

    # Hapus record havens lama kalau ada
    sed -i '/havens[[:space:]]\+IN[[:space:]]\+CNAME/d' "$ZONE_FILE"

    # Tambahkan record CNAME baru
    echo "havens      IN      CNAME   www.k08.com." >> "$ZONE_FILE"

    # Naikkan serial SOA secara otomatis
    sed -i -E 's/([0-9]{10})/\1+1/e' "$ZONE_FILE"

    echo "[OK] Zona k08.com diperbarui dengan CNAME havens → www.k08.com"
else
    echo "[ERROR] File zona tidak ditemukan: $ZONE_FILE"
    exit 1
fi

# Restart manual BIND9 karena tidak ada systemctl
echo "=== [2] Restart BIND9 di Tirion (Manual Mode) ==="
killall named 2>/dev/null
named -c /etc/bind/named.conf -f > /var/log/named.log 2>&1 &
sleep 3

# Verifikasi zona master
echo "=== [3] Verifikasi zona di Tirion ==="
dig havens.k08.com @127.0.0.1 +noall +answer

# ==========================================
# Sinkronisasi Slave (Valmar)
# ==========================================
echo "=== [4] Sinkronisasi Slave (Valmar) ==="
ssh root@192.215.3.3 'bash -s' <<'EOF'
echo "[Slave] Menghapus cache lama..."
rm -f /var/lib/bind/db.k08.com

echo "[Slave] Restart manual BIND9..."
killall named 2>/dev/null
named -c /etc/bind/named.conf -f > /var/log/named.log 2>&1 &
sleep 3

echo "[Slave] Verifikasi zona..."
dig havens.k08.com @127.0.0.1 +noall +answer
EOF

# ==========================================
# Verifikasi dari klien Sirion & Valmar
# ==========================================
echo "=== [5] Tes resolusi dari klien ==="
dig havens.k08.com @192.215.3.2 +short

echo "=== [6] Tes akses HTTP dari Sirion ==="
ssh root@192.215.3.6 'curl -v http://havens.k08.com --max-time 5 || echo "[!] Gagal konek ke web"'

echo "=== [7] Tes akses HTTP dari Valmar ==="
ssh root@192.215.3.3 'curl -v http://havens.k08.com --max-time 5 || echo "[!] Gagal konek ke web"'

echo "=== [Selesai] Nomor 19 Berhasil Diknfigurasi ==="

