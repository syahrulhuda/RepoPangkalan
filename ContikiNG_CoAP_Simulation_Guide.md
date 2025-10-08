# Panduan Sangat Lengkap: Simulasi CoAP Contiki-NG dengan Cooja dan Analisis Wireshark

Panduan ini akan memandu Anda melalui seluruh proses, mulai dari menyiapkan lingkungan pengembangan Contiki-NG hingga menjalankan simulasi CoAP di Cooja dan menganalisis lalu lintas jaringan dengan Wireshark.

---

## I. Prasyarat dan Instalasi Dependensi

Sebelum memulai, pastikan sistem Anda memenuhi prasyarat dan semua alat yang diperlukan telah terinstal. Asumsi sistem operasi adalah **Ubuntu/Debian-based Linux**.

### 1. Sistem Operasi
*   Distribusi Linux (misalnya, Ubuntu 20.04 LTS atau yang lebih baru).

### 2. Java Development Kit (JDK)
Cooja adalah aplikasi berbasis Java.
*   **Instal OpenJDK:**
    ```bash
    sudo apt update
    sudo apt install openjdk-11-jdk
    ```
*   **Verifikasi Instalasi:**
    ```bash
    java -version
    javac -version
    ```

### 3. Gradle
Cooja menggunakan Gradle untuk membangun dan menjalankannya.
*   **Instal Gradle:**
    ```bash
    sudo apt install gradle
    ```
*   **Verifikasi Instalasi:**
    ```bash
    gradle -v
    ```

### 4. Git
Diperlukan untuk mengkloning repositori Contiki-NG.
*   **Instal Git:**
    ```bash
    sudo apt install git
    ```
*   **Verifikasi Instalasi:**
    ```bash
    git --version
    ```

### 5. Toolchain GNU ARM Embedded (GCC ARM)
Meskipun simulasi Cooja tidak selalu memerlukan kompilasi silang untuk target hardware, Contiki-NG secara umum mengandalkan toolchain ini untuk kompilasi firmware. Menginstalnya adalah praktik terbaik.
*   **Instal Toolchain:**
    ```bash
    sudo apt install gcc-arm-none-eabi
    ```
*   **Verifikasi Instalasi:**
    ```bash
    arm-none-eabi-gcc --version
    ```

### 6. Wireshark
Alat analisis protokol jaringan.
*   **Instal Wireshark:**
    ```bash
    sudo apt install wireshark
    ```
*   **Konfigurasi Izin (Penting!):** Agar pengguna non-root dapat menangkap paket, Anda perlu menambahkan pengguna Anda ke grup `wireshark`.
    ```bash
    sudo usermod -a -G wireshark $USER
    ```
    *Anda perlu **logout dan login kembali** agar perubahan grup ini berlaku.*
*   **Verifikasi Instalasi:**
    ```bash
    wireshark --version
    ```

### 7. `sudo` dan Izin Pengguna
Beberapa perintah (seperti membuat antarmuka `tun0` atau menangkap paket dengan Wireshark/tshark) memerlukan hak akses `root`. Pastikan pengguna Anda memiliki hak `sudo`.

---

## II. Penyiapan Lingkungan Contiki-NG

### 1. Mengkloning Repositori Contiki-NG
*   **Pindah ke Direktori Home Anda:**
    ```bash
    cd ~
    ```
*   **Kloning Repositori:**
    ```bash
    git clone https://github.com/contiki-ng/contiki-ng.git
    ```
    Ini akan membuat direktori `contiki-ng` di direktori home Anda (`~/contiki-ng/`).

### 2. Kompilasi `tunslip6`
`tunslip6` adalah alat penting untuk menjembatani simulasi Cooja dengan antarmuka jaringan di sistem operasi Anda.

*   **Pindah ke Direktori `serial-io`:**
    ```bash
    cd ~/contiki-ng/tools/serial-io/
    ```
*   **Kompilasi `tunslip6`:**
    ```bash
    make tunslip6
    ```
    Ini akan membuat file eksekusi bernama `tunslip6` di direktori ini.
*   **Kembali ke Direktori Root `contiki-ng`:**
    ```bash
    cd ~/contiki-ng/
    ```

---

## III. Membuat Simulasi di Cooja

Sekarang kita akan membuat simulasi dengan Border Router, CoAP Server, dan CoAP Client.

### 1. Memulai Cooja
*   **Pindah ke Direktori Cooja:**
    ```bash
    cd ~/contiki-ng/tools/cooja/
    ```
*   **Jalankan Cooja:**
    ```bash
    ./gradlew run
    ```
    Ini akan membuka antarmuka grafis Cooja.

### 2. Buat Simulasi Baru
*   Di Cooja GUI, pilih **File -> New simulation...**.
*   Beri nama simulasi Anda, misalnya `Simulasi-CoAP-Benar`, lalu klik **Create**.

### 3. Tambahkan Mote Border Router (1 Mote)
*   Pilih **Motes -> Add motes -> Create new mote type -> Cooja mote**.
*   **Description:** `Border Router`
*   **Contiki-NG source file:** Klik **Browse** dan navigasikan ke `~/contiki-ng/examples/rpl-border-router/border-router.c`. Pilih file tersebut.
*   Klik **Compile**, tunggu hingga proses selesai, lalu klik **Create**.
*   Pada dialog "Add motes", masukkan `1` (untuk 1 mote), lalu klik **Add motes**.

### 4. Tambahkan Mote CoAP Server (2 Mote)
*   Pilih **Motes -> Add motes -> Create new mote type -> Cooja mote**.
*   **Description:** `CoAP Server`
*   **Contiki-NG source file:** Klik **Browse** dan navigasikan ke `~/contiki-ng/examples/coap/coap-example-server/coap-example-server.c`. Pilih file tersebut.
*   Klik **Compile**, tunggu hingga proses selesai, lalu klik **Create`.
*   Pada dialog "Add motes", masukkan `2` (untuk 2 mote), lalu klik **Add motes**.

### 5. Tambahkan Mote CoAP Client (2 Mote)
*   Pilih **Motes -> Add motes -> Create new mote type -> Cooja mote**.
*   **Description:** `CoAP Client`
*   **Contiki-NG source file:** Klik **Browse** dan navigasikan ke `~/contiki-ng/examples/coap/coap-example-client/coap-example-client.c`. Pilih file tersebut.
*   Klik **Compile**, tunggu hingga proses selesai, lalu klik **Create**.
*   Pada dialog "Add motes", masukkan `2` (untuk 2 mote), lalu klik **Add motes**.

### 6. Konfigurasi Serial Socket untuk Border Router (Mote 1)
Ini adalah langkah krusial untuk menghubungkan simulasi ke Wireshark.

*   **Hentikan Simulasi:** Di jendela "Simulation control", klik tombol **Stop**.
*   **Hapus Semua Mote:** Di jendela "Network", klik pada setiap mote (Mote 1, 2, 3, 4, 5) dan tekan tombol `Delete` pada keyboard Anda, atau klik kanan -> "Delete mote(s)". Ini untuk memastikan konfigurasi baru diterapkan dengan bersih.
*   **Edit Mote Type "Border Router":**
    *   Buka menu **Motes -> Edit mote types...**.
    *   Pilih `border-router` dari daftar dan klik **Edit**.
    *   Di jendela "Contiki Mote Type", klik tab **"Interfaces"**.
    *   Gulir ke bawah dan klik pada **`ContikiRS232`**.
    *   Ubah pengaturannya dari "Log listener" (atau apa pun itu) menjadi **"Serial Socket (SERVER)"**.
    *   Klik **OK** untuk menyimpan perubahan pada mote type.
*   **Buat Ulang Mote:**
    *   Sekarang, buat kembali mote-mote Anda seperti sebelumnya (langkah 3, 4, 5 di atas). Pastikan Anda membuat 1 Border Router, 2 CoAP Server, dan 2 CoAP Client.

### 7. Atur Posisi Mote dan Mulai Simulasi
*   Di jendela "Network", atur posisi mote-mote tersebut. Tempatkan Border Router (Mote 1) di tengah, dan sebarkan server serta client di sekelilingnya.
*   Di jendela "Simulation control", klik tombol **Start**.
*   Anda akan melihat garis-garis (menandakan rute RPL) mulai terbentuk menuju Border Router.

---

## IV. Menghubungkan Simulasi ke Sistem Host (`tunslip6`)

Sekarang kita akan menggunakan `tunslip6` untuk membuat jembatan antara simulasi Cooja dan antarmuka jaringan `tun0` di sistem Anda.

### 1. Aktifkan Plugin "Serial Socket (SERVER)" di Cooja
*   **Pastikan Simulasi Berjalan:** Pastikan simulasi Anda sedang dalam keadaan berjalan di Cooja.
*   **Klik Kanan pada Border Router (Mote 1):** Di jendela "Network", klik kanan pada Mote 1 (Border Router).
*   **Pilih Alat Soket Serial:** Dari menu konteks, arahkan ke **More tools... -> Serial socket (SERVER)**.
*   **Mulai Plugin Soket Serial:** Sebuah jendela baru akan muncul dengan judul "Serial Socket (SERVER) - Mote 1". Di dalam jendela ini, klik tombol **Start**.
    *   **Penting:** Perhatikan bahwa jendela ini akan menampilkan "Listening on port 60001". Ini mengkonfirmasi bahwa Cooja menggunakan port UDP 60001 untuk komunikasi serial.

### 2. Jalankan `tunslip6` dengan Koneksi UDP
Buka **terminal baru** (jangan tutup terminal Cooja).

*   **Pindah ke Direktori Root `contiki-ng`:**
    ```bash
    cd ~/contiki-ng/
    ```
*   **Jalankan Perintah `tunslip6`:**
    ```bash
    sudo ./tools/serial-io/tunslip6 -v -a 127.0.0.1 -p 60001 aaaa::1/64
    ```
    *   Anda akan diminta kata sandi `sudo`.
    *   Perintah ini akan terhubung ke Cooja melalui port UDP 60001, membuat antarmuka `tun0`, dan mengkonfigurasinya dengan prefix IPv6 `aaaa::1/64`.
    *   **Biarkan terminal ini tetap berjalan.** `tunslip6` adalah proses yang berjalan terus-menerus dan tidak akan kembali ke prompt sampai Anda menghentikannya (misalnya, dengan Ctrl+C).

*   **Verifikasi di Cooja:**
    *   Perhatikan output di jendela "Mote Output" di Cooja. Mote Border Router (Mote 1) seharusnya sekarang mencetak alamat IPv6 globalnya (misalnya, `aaaa::201:1:1:1`).
    *   Mote CoAP Server dan CoAP Client juga seharusnya mulai mendapatkan alamat IPv6 global yang dimulai dengan `aaaa::`. Pesan "Waiting for prefix" seharusnya sudah hilang dari semua mote.

---

## V. Menganalisis Lalu Lintas dengan Wireshark

Setelah `tunslip6` berjalan dan mote-mote mendapatkan alamat IPv6, kita bisa mulai menganalisis lalu lintas jaringan.

### 1. Membuka Wireshark
*   Buka aplikasi Wireshark dari menu aplikasi Anda atau dengan mengetik `wireshark` di terminal baru (lalu tekan Enter).

### 2. Memilih Antarmuka `tun0`
*   Di jendela utama Wireshark, Anda akan melihat daftar antarmuka jaringan yang tersedia.
*   Cari dan klik dua kali pada antarmuka **`tun0`**.

### 3. Menerapkan Filter CoAP
*   Di bagian "Display Filter" di Wireshark (biasanya di bagian atas jendela), ketik `coap` dan tekan Enter.
*   Anda sekarang akan melihat paket-paket CoAP yang dikirim oleh mote CoAP Client (permintaan GET) dan balasan dari mote CoAP Server (2.05 Content). Anda bisa mengklik paket-paket ini untuk melihat detail header dan payload CoAP.

---
