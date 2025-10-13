#!/bin/bash
# ==============================================
# Nomor 15 - ApacheBench Performance Test
# Kelompok: K08
# ==============================================

TARGET="www.k08.com"
REQ=500
CONC=10

echo "[1/3] Installing ApacheBench..."
apt update -y && apt install apache2-utils -y

echo "[2/3] Running tests..."
ab -n $REQ -c $CONC http://$TARGET/app/ > /root/ab_app_result.txt
ab -n $REQ -c $CONC http://$TARGET/static/ > /root/ab_static_result.txt

echo "============================================="
echo "✅ ApacheBench testing complete!"
echo "Results saved to:"
echo "  /root/ab_app_result.txt"
echo "  /root/ab_static_result.txt"
echo "============================================="

# Optional summary extraction
echo -e "\nSummary Table:"
echo "---------------------------------------------------------"
echo "| Endpoint | Requests/sec | Time/req (ms) | Transfer Rate |"
echo "---------------------------------------------------------"
for TYPE in app static; do
    RPS=$(grep "Requests per second" /root/ab_${TYPE}_result.txt | awk '{print $4}')
    TIME=$(grep "Time per request:" /root/ab_${TYPE}_result.txt | head -1 | awk '{print $4}')
    RATE=$(grep "Transfer rate" /root/ab_${TYPE}_result.txt | awk '{print $3" "$4}')
    printf "| /%-7s | %-13s | %-14s | %-14s |\n" "$TYPE/" "$RPS" "$TIME" "$RATE"
done
echo "---------------------------------------------------------"

