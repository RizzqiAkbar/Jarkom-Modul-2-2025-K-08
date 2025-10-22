# Jarkom-Modul-2-2025-K-08

Anggota :
|NRP|NAMA|
|---|---|
|5027241044|Rizqi Akbar S.P.|
5027241117|Adinda Cahya Pramesti|

## TOPOLOGI
<img width="1496" height="1347" alt="image" src="https://github.com/user-attachments/assets/5863c987-866c-4bcd-bbfd-c41e58ca640f" />

## Soal 1
### Configure
## Soal 1 - Soal 2 - Soal 3
### Configure
#### Eonwe
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.215.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.215.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.215.3.1
	netmask 255.255.255.0
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.215.0.0/16
```
#### Earendil
```
auto eth0
iface  eth0 inet static
  address 192.215.1.2
  netmask 255.255.255.0
  gateway 192.215.1.1

up echo nameserver 192.168.122.1 >>  /etc/resolv.conf
```

#### Elwing
```
auto eth0
iface  eth0 inet static
  address 192.215.1.3
  netmask 255.255.255.0
  gateway 192.215.1.1

up echo nameserver 192.168.122.1 >>  /etc/resolv.conf
```

#### Cildan
```
auto eth0
iface eth0 inet static
	address 192.215.2.2
	netmask 255.255.255.0
	gateway 192.215.2.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Elrond
```
auto eth0
iface eth0 inet static
	address 192.215.2.3
	netmask 255.255.255.0
	gateway 192.215.2.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Maglor
```
auto eth0
iface eth0 inet static
	address 192.215.2.4
	netmask 255.255.255.0
	gateway 192.215.2.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Sirion
```
auto eth0
iface eth0 inet static
	address 192.215.3.6
	netmask 255.255.255.0
	gateway 192.215.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Tirion
```
auto eth0
iface eth0 inet static
	address 192.215.3.2
	netmask 255.255.255.0
	gateway 192.215.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Valmar
```
auto eth0
iface eth0 inet static
	address 192.215.3.3
	netmask 255.255.255.0
	gateway 192.215.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Lindon
```
auto eth0
iface eth0 inet static
	address 192.215.3.4
	netmask 255.255.255.0
	gateway 192.215.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

#### Vingilot
```
auto eth0
iface eth0 inet static
	address 192.215.3.5
	netmask 255.255.255.0
	gateway 192.215.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
### Dokumentasi Soal 2
![WhatsApp Image 2025-10-20 at 19 16 21_7f6d1114](https://github.com/user-attachments/assets/4352fb14-7d64-43b7-88cf-ea879938a803)
uji coba ping keluar client

### Dokumentasi Soal 3
![WhatsApp Image 2025-10-20 at 19 26 40_77b5e677](https://github.com/user-attachments/assets/267ab438-7d83-4e48-896b-8a0a1b165803)
- uji coba ping ke Elrond lewat Earendil
- uji coba ping 8.8.8.8 dan google.com


## Soal 4
Diminta membuat dua server DNS:
- Tirion → ns1, bertindak sebagai master (authoritative utama)
- Valmar → ns2, bertindak sebagai slave (cadangan)
Nanti akan mengatur nama domain k08.com.com.
### Output
![WhatsApp Image 2025-10-20 at 19 13 30_99d21f7f](https://github.com/user-attachments/assets/b64ddc07-821f-4979-9ae7-e40ce5505ea3)
- uji coba dari valmar menggunakan dig

![WhatsApp Image 2025-10-20 at 19 19 06_25a02006](https://github.com/user-attachments/assets/7c37e959-443a-4c17-ba09-d85751a1046a)
- uji coba dari valmar menggunakan ping

![WhatsApp Image 2025-10-20 at 19 13 55_d6dd5cd5](https://github.com/user-attachments/assets/69ed8851-433b-4e97-bdcf-e4c0f7a3a968)
- uji coba dari tirion menggunakan dig


## Soal 5
Pada percobaan ini dilakukan konfigurasi DNS Server dengan model master–slave menggunakan Bind9 pada dua node:
- Tirion (ns1) bertindak sebagai DNS Master (authoritative utama) untuk domain `k08.com.`
- Valmar (ns2) bertindak sebagai DNS Slave, yang akan melakukan sinkronisasi otomatis dari master menggunakan fitur zone transfer.

1. Instalasi Paket
- Menginstal `bind9`, `bind9utils`, dan `bind9-doc` untuk layanan DNS.

2. Membuat Zona `k08.com`
- Diset sebagai type master.
- File zona disimpan di `/etc/bind/zones/db.k08.com`.
- allow-transfer memberikan izin transfer ke Valmar `(192.215.3.3)`.
- notify yes mengaktifkan pemberitahuan otomatis ke slave setiap ada perubahan.

3. File Zona (db.k08.com)
- Berisi record SOA, NS, dan A record untuk setiap host sesuai glosarium.
- `@ IN A 192.215.3.6` menunjuk ke Sirion sebagai apex domain `(k08.com)`.

4. Konfigurasi Forwarder
- Domain eksternal diteruskan ke DNS upstream `192.168.122.1`.

5. Validasi & Restart
- Diperiksa dengan named-checkconf dan named-checkzone untuk memastikan tidak ada kesalahan sintaks.
- Service Bind9 direstart agar konfigurasi aktif.

Script: VALMAR.sh
1. Konfigurasi Zona Slave
- type slave menandakan Valmar hanya menerima data dari master `(192.215.3.2)`.
- File hasil transfer otomatis disimpan di `/var/lib/bind/db.k08.com`.

2. Forwarder & Query
- Sama seperti master, mengizinkan query dari semua host dan meneruskan domain luar ke `192.168.122.1`.

3. Sinkronisasi Otomatis
- Saat service Bind9 diaktifkan, Valmar akan melakukan zone transfer otomatis dari Tirion.

## Soal 6

## Soal 7

## Soal 8

## Soal 9

## Soal 10

## Soal 11
Konfigurasi ini memanfaatkan satu node Sirion sebagai reverse proxy yang melakukan path-based routing, serta dua node backend—Lindon untuk konten /static/ dan Vingilot untuk konten /app/. Setiap node menjalankan Nginx dengan konfigurasi minimal, sementara skrip bash otomatis menyiapkan file hosts, direktori konten, dan konfigurasi Nginx.
- Sirion (192.215.3.6)
• Menggunakan iptables NAT masquerading untuk akses jaringan keluar
• Menjalankan Nginx dengan dua blok location yang mem-proxy permintaan /static/ ke Lindon dan /app/ ke Vingilot
- Lindon (192.215.3.4)
• Menyajikan direktori /var/www/html/static/ di lokasi /static/
• Konfigurasi Nginx menggunakan alias agar konten statis dapat diakses secara langsung
- Vingilot (192.215.3.5)
• Menyajikan direktori /var/www/html/app/ di lokasi /app/
• Struktur konfigurasi serupa Lindon untuk isolasi path aplikasi
Pengujian curl -I http://www.K08.com/static/ dan curl -I http://www.K08.com/app/ harus mengembalikan status 200 OK. Permintaan konten tanpa header (misalnya curl http://www.K08.com/static/) menampilkan pesan “Halo dari Lindon…” atau “Halo dari Vingilot…” sesuai endpoint.
<img width="571" height="98" alt="Screenshot 2025-10-12 145842" src="https://github.com/user-attachments/assets/41b1f099-e240-4c01-ac08-1b9729c3d46d" />

### Revisi
Menggunakan lynx saat ingin mencoba apakah reverse proxy tersambung
<img width="479" height="145" alt="Screenshot 2025-10-22 230518" src="https://github.com/user-attachments/assets/894d05ff-3eac-4504-a6f0-d84ecadc18a3" />
<img width="502" height="159" alt="Screenshot 2025-10-22 230527" src="https://github.com/user-attachments/assets/ea96026b-02f0-4e77-bb5e-c8ae29370696" />

## Soal 12
Node Sirion di-update dan dilengkapi Nginx serta apache2-utils untuk mendukung path-based routing ke backend (/static/ dan /app/) sekaligus menambah endpoint /admin dengan simulasi Basic Auth.

Persiapan Sistem
- Jalankan apt update untuk memperbarui daftar paket.
- Install Nginx dan apache2-utils (apt install nginx apache2-utils -y) untuk Nginx dan utilitas pembuatan file .htpasswd.

Pembuatan File Password (Opsional)
- Buat file /etc/nginx/.htpasswd dengan htpasswd -c /etc/nginx/.htpasswd admin komdat.
- File ini hanya untuk dokumentasi—modul http_auth_basic tidak aktif sehingga autentikasi di-simulasi di konfigurasi Nginx.

Konfigurasi Nginx
- Backup konfigurasi lama:
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
- Edit atau tulis ulang /etc/nginx/nginx.conf dengan:
- Path-based proxy /static/ → http://192.215.3.4
- Path-based proxy /app/ → http://192.215.3.5
- Simulasi Basic Auth di /admin menggunakan pengecekan header Authorization
- Default root di / mengarah ke /var/www/html/index.html
- Simpan dan pastikan sintaks valid dengan nginx -t.
- Reload Nginx: nginx -s reload.

Pengujian Endpoint /admin
- Tanpa kredensial:
```
curl -v http://www.k08.com/admin
```
→ 401 Unauthorized - Please provide credentials
- Dengan kredensial (admin:admin):
```
curl -u admin:admin http://www.k08.com/admin
```
→ Welcome Admin - Access Granted (Simulated Auth)


## Soal 13
Node Sirion diperbarui dan dipastikan menjalankan Nginx sebelum menambahkan mekanisme redirect IP ke hostname www.k08.com. Dengan menambahkan blok server baru pada konfigurasi Nginx, setiap permintaan ke alamat IP primer akan diarahkan permanen (HTTP 301) ke domain resmi, tanpa menghilangkan path yang diminta.
Langkah Utama
- Perbarui paket dan pasang Nginx:
apt update && apt install -y nginx
- Tambahkan blok server di dalam http { … } untuk mendengarkan IP (misal 192.215.3.6) dan return 301 http://www.k08.com$request_uri;
- Siapkan direktori root /var/www/html, atur kepemilikan www-data:www-data, dan buat halaman utama sederhana dengan link ke /app dan /static.
- Validasi konfigurasi (nginx -t) dan reload Nginx (nginx -s reload).
Pengujian
- Akses via IP:
curl -I http://192.215.3.6
→ 301 Moved Permanently + Location: http://www.k08.com/
- Akses via subdomain sirion.k08.com atau domain www.k08.com:
curl -I http://sirion.k08.com / curl -I http://www.k08.com
→ 200 OK

<img width="501" height="196" alt="Screenshot 2025-10-12 155718" src="https://github.com/user-attachments/assets/63f16b6a-ba94-48cd-98b6-3f007411ca26" />


## Soal 14
Node Sirion berfungsi sebagai reverse proxy yang melewatkan informasi IP asli klien ke backend, sementara Vingilot mencatat header tersebut dalam log akses.
1. Persiapan Sirion
- Update paket dan pasang Nginx:
```
apt update -y
apt install -y nginx
```

2. Konfigurasi Proxy Header di Sirion
Pada setiap blok location yang mem-proxy (/static/ & /app/), tambahkan:
```
proxy_set_header X-Real-IP           $remote_addr;
proxy_set_header X-Forwarded-For     $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto   $scheme;
```
```
location /app/ {
    proxy_pass http://192.215.3.5;
    proxy_set_header Host             $host;

    # Nomor 14 – Real-IP forwarding
    proxy_set_header X-Real-IP        $remote_addr;
    proxy_set_header X-Forwarded-For  $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

Reload Nginx setelah validasi:
nginx -t && nginx -s reload


3. Konfigurasi Logging di Vingilot
Tambahkan format log khusus supaya mencatat header X-Real-IP:
```
log_format realip '$remote_addr - $remote_user [$time_local] '
                  '"$request" $status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" RealIP=$http_x_real_ip';
access_log /var/log/nginx/access.log realip;
```

Reload Nginx di Vingilot:
```
nginx -t && nginx -s reload
```

4. Verifikasi Akses lewat Sirion
Pastikan Elrond memetakan domain ke Sirion:
```
echo "192.215.3.6 www.k08.com sirion.k08.com" >> /etc/hosts
```
```
curl http://www.k08.com/app/
```
```
tail -n 5 /var/log/nginx/access.log
```
Baris log yang valid akan menampilkan RealIP=192.215.3.6 di akhir.
<img width="750" height="54" alt="Screenshot 2025-10-12 182307" src="https://github.com/user-attachments/assets/32533789-edc5-4ca6-baa8-81ee7875c639" />

## Soal 15
Mengukur performa endpoint /app/ (Vingilot) dan /static/ (Lindon) di balik Sirion menggunakan ApacheBench (ab).

1. Instalasi ApacheBench di Elrond
```
apt update -y
apt install apache2-utils -y
```

3. Pastikan Domain Mengarah ke Sirion
Tambahkan baris berikut ke /etc/hosts di Elrond agar www.k08.com dan sirion.k08.com resolve ke IP Sirion (192.215.3.6):
```
echo "192.215.3.6 www.k08.com sirion.k08.com" >> /etc/hosts
```

5. Menjalankan Uji Beban
- Untuk /app/ (backend Vingilot):
```
ab -n 500 -c 10 http://www.k08.com/app/
```
- Untuk /static/ (backend Lindon):
```
ab -n 500 -c 10 http://www.k08.com/static/
```

Hasil :
```
root@Elrond:~# ab -n 500 -c 10 http://www.k08.com/static/
This is ApacheBench, Version 2.3 <$Revision: 1923142 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking www.k08.com (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Finished 500 requests


Server Software:        nginx/1.26.3
Server Hostname:        www.k08.com
Server Port:            80

Document Path:          /static/
Document Length:        35 bytes

Concurrency Level:      10
Time taken for tests:   0.108 seconds
Complete requests:      500
Failed requests:        0
Total transferred:      133000 bytes
HTML transferred:       17500 bytes
Requests per second:    4619.66 [#/sec] (mean)
Time per request:       2.165 [ms] (mean)
Time per request:       0.216 [ms] (mean, across all concurrent requests)
Transfer rate:          1200.03 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   0.2      1       1
Processing:     1    2   0.5      1       5
Waiting:        1    1   0.5      1       4
Total:          1    2   0.7      2       6
WARNING: The median and mean for the processing time are not within a normal deviation
        These results are probably not that reliable.

Percentage of the requests served within a certain time (ms)
  50%      2
  66%      2
  75%      2
  80%      2
  90%      3
  95%      4
  98%      4
  99%      5
 100%      6 (longest request)

```
## Soal 16
- Edit /etc/bind/db.k08.com: naikkan serial, perbarui SOA/NS/A/CNAME sesuai IP terbaru.
- Restart BIND tanpa systemctl: kill proses named via /proc loop atau rndc reload, lalu jalankan named -c /etc/bind/named.conf &.
- Verifikasi DNS:
```
dig lindon.k08.com @127.0.0.1 +noall +answer
```
- Reload Nginx/PHP-FPM di masing-masing node tanpa ps/systemctl:
- Nginx: nginx -t && nginx -s reload (atau stop/start)
- PHP-FPM: kill -USR2 $(cat /run/php/php8.4-fpm.pid) (atau stop/start)
- Cek layanan aktif:
```
netstat -tuln | egrep ":53|:80"
```

## Soal 17
- DNS Master (Tirion):
• /etc/bind/named.conf.local → zone k08.com type master, allow-transfer & also-notify ke Valmar.
• Zona di /etc/bind/db.k08.com dengan SOA, NS, A records, CNAME.
- DNS Slave (Valmar):
• /etc/bind/named.conf.local → zone k08.com type slave, masters { 192.215.3.2; }, file zona lokal.
• Opsi di /etc/bind/named.conf.options untuk query dan transfer.
- Autostart via /etc/rc.local:
• Tirion & Valmar → named -f (BIND master/slave).
• Sirion & Lindon → nginx.
• Vingilot → php-fpm8.4 lalu nginx.
• Pastikan /etc/rc.local executable.
- Aktivasi & Verifikasi:
- chmod +x /etc/rc.local
- Jalankan bash /etc/rc.local atau reboot.
- Cek port: netstat -tuln | egrep ":53|:80".
- Uji AXFR di Valmar: dig @192.215.3.2 k08.com AXFR.
- Uji resolusi/web: dig @192.215.3.3 lindon.k08.com, curl http://app.k08.com/info.php.

## Soal 18
- Tirion (Master):
- Edit /etc/bind/db.k08.com → tambahkan
• melkor IN TXT "Morgoth (Melkor)"
• morgoth IN CNAME melkor.k08.com.
• Naikkan serial SOA (contoh: 2025101203 → 2025101204).
- Validasi zona:
```
named-checkzone k08.com /etc/bind/db.k08.com
```
- Reload BIND:
```
killall named
named -c /etc/bind/named.conf -f &> /var/log/named.log &
```
- Valmar (Slave):
- Restart BIND slave sama seperti master:
```
killall named
named -c /etc/bind/named.conf -f &> /var/log/named.log &
```
- Verifikasi sinkronisasi:
```
dig melkor.k08.com TXT @192.215.3.2 +short    # "Morgoth (Melkor)"
dig morgoth.k08.com CNAME @192.215.3.2 +short # melkor.k08.com.
dig @127.0.0.1 lindon.k08.com +noall +answer  # A 192.168.3.20 (master & slave)
```

## Soal 19
- Edit /etc/bind/db.k08.com di Tirion:
• Pastikan www IN A 192.215.3.6
• Tambahkan havens    IN CNAME   www.k08.com.
• Naikkan nomor serial SOA
- Restart BIND Master secara manual:
```
killall named
named -c /etc/bind/named.conf -f &
```
- Sinkronisasi di Valmar (Slave):
```
rm -f /var/lib/bind/db.k08.com
killall named
named -c /etc/bind/named.conf -f &
```
- Verifikasi di kedua node:
```
dig havens.k08.com @127.0.0.1 +noall +answer
```
- Uji dari klien:
```
curl -v http://havens.k08.com
```

Jika kedua DNS menampilkan havens.k08.com → CNAME www.k08.com dan HTTP berhasil, konfigurasi selesai.

## Soal 20
- Buat direktori dan homepage
```
mkdir -p /var/www/html
cat > /var/www/html/index.html <<'EOF'
<!-- HTML War of Wrath… -->
EOF
```
- Konfigurasi Virtual Host di Sirion
- File /etc/nginx/sites-available/www.k08.com:
```
server {
  listen 80;
  server_name www.k08.com;
  root /var/www/html;
  index index.html;

  location / { try_files $uri $uri/ =404; }
  location /app { proxy_pass http://192.215.3.5; }
  location /static { proxy_pass http://192.215.2.3; }
}
```
- Aktifkan & reload:
```
ln -sf /etc/nginx/sites-available/www.k08.com /etc/nginx/sites-enabled/
nginx -t && nginx -s reload
```
- Pastikan DNS menunjuk ke Sirion
```
dig www.k08.com @127.0.0.1 +short  # → 192.215.3.6
```
- Verifikasi dari klien
```
curl -I http://www.k08.com
curl -I http://www.k08.com/app
curl -I http://www.k08.com/static
```
- Troubleshooting
- Periksa resolv.conf pastikan nameserver 192.215.3.2
- Gunakan nginx -t && nginx -s reload bila systemctl tak ada
- Cek netstat -tuln | grep :80 untuk memastikan Nginx listen
Dengan langkah ini, homepage grup K08 aktif di /, /app proxy ke Vingilot, dan /static proxy ke Lindon.

### Revisi
Menggunakan lynx 
<img width="1478" height="762" alt="Screenshot 2025-10-22 230506" src="https://github.com/user-attachments/assets/62022a5f-725f-4dae-a069-8c5b2c1d5c0b" />
