#!/bin/bash
# ===============================================

echo "🧠 Setting up autostart for $(hostname)..."

case "$(hostname)" in
  Tirion)
    cat > /etc/rc.local <<'EOF'
#!/bin/bash
echo "[Tirion] Starting Bind9 Master..."
named -c /etc/bind/named.conf -f > /var/log/named.log 2>&1 &
exit 0
EOF
    ;;
  Valmar)
    cat > /etc/rc.local <<'EOF'
#!/bin/bash
echo "[Valmar] Starting Bind9 Slave..."
named -c /etc/bind/named.conf -f > /var/log/named.log 2>&1 &
exit 0
EOF
    ;;
  Sirion)
    cat > /etc/rc.local <<'EOF'
#!/bin/bash
echo "[Sirion] Starting Nginx Reverse Proxy..."
nginx
exit 0
EOF
    ;;
  Lindon)
    cat > /etc/rc.local <<'EOF'
#!/bin/bash
echo "[Lindon] Starting Nginx Web Server..."
nginx
exit 0
EOF
    ;;
  Vingilot)
    cat > /etc/rc.local <<'EOF'
#!/bin/bash
echo "[Vingilot] Starting PHP-FPM & Nginx..."
php-fpm8.4
nginx
exit 0
EOF
    ;;
esac

chmod +x /etc/rc.local
echo "✅ Autostart configured for $(hostname)"

