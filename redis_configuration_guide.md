# 📚 Panduan Konfigurasi Redis (`koda-b9-db`)

Dokumentasi ini mencakup penjelasan dan contoh konfigurasi untuk server Redis, mulai dari pengaturan jaringan, _logging_, persistensi data, manajemen memori, hingga manajemen pengguna berbasis ACL.

---

## 1. Network Settings (`bind`, `port`)

Pengaturan jaringan mengontrol bagaimana klien dapat terhubung ke server Redis demi alasan keamanan dan fleksibilitas jaringan.

- **`bind`**: Menentukan alamat IP mana yang diizinkan untuk menerima koneksi masuk.
  - `bind 127.0.0.1`: Redis hanya dapat diakses secara lokal dari mesin yang sama (paling aman untuk lingkungan _development_ tunggal).
  - `bind 0.0.0.0`: Mengizinkan koneksi dari semua antarmuka jaringan (biasanya digunakan di dalam kontainer Docker atau server produksi yang dilindungi _firewall_ / _private network_).
- **`port`**: Menentukan port TCP tempat Redis mendengarkan koneksi masuk. Port default Redis adalah **`6379`**.

### Contoh di `redis.conf`:

```text
bind 0.0.0.0
port 6379
```

---

## 2. Logging (`logfile`, `loglevel`)

Pengaturan log membantu administrator memantau kesehatan server, mendeteksi _error_, dan melakukan _debugging_.

- **`loglevel`**: Menentukan tingkat detail informasi yang dicatat ke dalam log. Pilihannya meliputi:
  - `debug`: Informasi yang sangat detail, bagus untuk pengembangan atau _debugging_ masalah pelik.
  - `verbose`: Informasi yang cukup banyak namun tidak sedetail _debug_.
  - `notice` (Default): Moderat, cocok untuk lingkungan produksi karena tidak menghasilkan file log yang terlalu membengkak.
  - `warning`: Hanya mencatat kejadian penting atau error kritis.
- **`logfile`**: Menentukan lokasi jalur (_path_) file tempat log disimpan. Jika dikosongkan (`""`), log akan dikirim ke _standard output_ (`stdout` / terminal).

### Contoh di `redis.conf`:

```text
loglevel notice
logfile "/var/log/redis/redis-server.log"
```

---

## 3. Persistence (RDB vs AOF, Mengapa Menggunakan Keduanya?)

Redis adalah _in-memory database_, sehingga data disimpan di RAM. Agar data tidak hilang saat server _restart_ atau mati lampu, Redis menyediakan dua mekanisme persistensi:

- **RDB (Redis Database / Snapshotting)**: Menyimpan salinan (_snapshot_) dari seluruh dataset dalam bentuk file terkompresi (`dump.rdb`) pada interval waktu tertentu (misal: setiap 60 detik jika ada minimal 1 perubahan).
  - _Kelebihan_: Ukuran file lebih kecil, _recovery_ (pemulihan) data saat _startup_ jauh lebih cepat.
  - _Kekurangan_: Ada risiko kehilangan data jika terjadi _crash_ di antara jeda waktu _snapshot_.
- **AOF (Append Only File)**: Mencatat setiap perintah tulis (_write operation_) yang diterima server secara _real-time_ ke dalam file log.
  - _Kelebihan_: Lebih aman dari kehilangan data (hampir tidak ada data yang hilang jika diset `fsync everysec`).
  - _Kekurangan_: Ukuran file cenderung lebih besar dan proses _restart/recovery_ lebih lambat dibandingkan RDB.

### Mengapa Menggunakan Keduanya?

Mengaktifkan keduanya secara bersamaan memberikan keseimbangan terbaik antara **keamanan data** dan **kecepatan pemulihan**. Jika terjadi kegagalan sistem, Redis akan menggunakan AOF (yang datanya lebih akurat/terkini) untuk memulihkan data, sementara RDB digunakan sebagai cadangan _snapshot_ yang efisien.

### Contoh di `redis.conf`:

```text
# Konfigurasi RDB (Snapshot setiap 60 detik jika ada min. 1 key berubah)
save 60 1
dbfilename dump.rdb

# Konfigurasi AOF
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
```

---

## 4. Memory Management (`maxmemory-policy`, Volatile vs Allkeys, LFU vs LRU)

Ketika batas memori RAM (`maxmemory`) yang dialokasikan untuk Redis sudah penuh, Redis memerlukan kebijakan (_eviction policy_) untuk menghapus kunci lama guna menyediakan ruang bagi data baru.

- **Volatile vs Allkeys:**
  - `volatile-*`: Kebijakan hanya diterapkan pada kunci-kunci yang sudah memiliki masa kedaluwarsa (TTL) diset. Kunci tanpa TTL akan diabaikan/dipertahankan.
  - `allkeys-*`: Kebijakan diterapkan ke seluruh kunci di dalam database, terlepas apakah kunci tersebut memiliki TTL atau tidak.
- **LRU vs LFU vs Random:**
  - **LRU (Least Recently Used)**: Menghapus kunci yang **paling lama tidak diakses** (berdasarkan waktu akses terakhir).
  - **LFU (Least Frequently Used)**: Menghapus kunci yang **paling jarang digunakan** (berdasarkan frekuensi seberapa sering kunci tersebut dibaca/ditulis). Seringkali lebih akurat dibanding LRU karena memperhitungkan pola kepopuleran data.
  - **Random**: Menghapus kunci secara acak.

### Kebijakan Populer:

- `volatile-lru` / `allkeys-lru`
- `volatile-lfu` / `allkeys-lfu`

### Contoh di `redis.conf`:

```text
maxmemory 256mb
maxmemory-policy volatile-lru
```

---

## 5. User Management (`acl`, `auth`, Cara Membuat User Baru)

Sejak versi 6, Redis mendukung **ACL (Access Control Lists)** yang memungkinkan pembuatan banyak pengguna dengan hak akses (_permissions_) yang spesifik untuk keamanan tingkat lanjut (menggantikan perintah `AUTH` global lama).

- **`auth`**: Autentikasi sandi (metode lama / kompatibilitas ke belakang).
- **`acl`**: Sistem kontrol akses berbasis perintah dan kunci.

### Cara Membuat User Baru:

Anda dapat membuat user baru langsung melalui CLI Redis menggunakan perintah `ACL SETUSER`:

```text
ACL SETUSER <nama_user> on >password_kuat ~<pattern_kunci>* +@all
```

- `on`: Mengaktifkan user.
- `>password_kuat`: Menetapkan _password_ (tanda `>` menunjukkan _plain-text password_ yang otomatis di-hash oleh Redis).
- `~<pattern_kunci>*`: Membatasi akses user hanya pada kunci dengan awalan tertentu (misal: `~session:*`).
- `+@all`: Memberikan izin untuk mengeksekusi semua perintah Redis (atau bisa dibatasi seperti `+get +set`).
