#!/bin/bash
# ==============================================

echo "🔄 Reloading Services..."

case "$(hostname)" in
  Tirion)
    echo "[Tirion] Reloading Bind9 (DNS Master)"
    killall named 2>/dev/null
    named -c /etc/bind/named.conf -f > /var/log/named.log 2>&1 &
    ;;

  Valmar)
    echo "[Valmar] Reloading Bind9 (DNS Slave)"
    killall named 2>/dev/null
    named -c /etc/bind/named.conf -f > /var/log/named.log 2>&1 &
    ;;

  Sirion|Lindon)
    echo "[$(hostname)] Reloading Nginx"
    nginx -t && nginx -s reload || { nginx -s stop; nginx; }
    ;;

  Vingilot)
    echo "[Vingilot] Reloading PHP-FPM & Nginx"
    if [ -f /run/php/php8.4-fpm.pid ]; then
        kill -USR2 $(cat /run/php/php8.4-fpm.pid)
    else
        php-fpm8.4
    fi
    nginx -t && nginx -s reload || { nginx -s stop; nginx; }
    ;;
esac

echo "✅ Reload complete!"
netstat -tuln | egrep ":53|:80"

