# Panduan Lengkap Simulasi MQTT: Cooja + Contiki-NG (Versi Final)

Dokumen ini adalah panduan sistematis untuk menyiapkan dan menjalankan simulasi MQTT, menghubungkan node Contiki-NG di dalam Cooja ke broker MQTT di komputer host.

---

## Konsep Dasar

- **Broker MQTT:** Berjalan di komputer host, bertugas menerima dan meneruskan pesan.
- **Border Router (BR):** Node di Cooja yang menjadi "pintu gerbang" antara jaringan nirkabel dan jaringan host.
- **MQTT Client:** Node di Cooja yang menjadi perangkat sensor/aktuator.
- **tunslip6:** Program di host yang membuat *tunnel* (`tun0`) agar host dan BR bisa berkomunikasi.

**Alur Koneksi yang Benar:**
1.  **Cooja (Border Router)** bertindak sebagai **SERVER** yang membuka port dan menunggu koneksi.
2.  **`tunslip6`** di host bertindak sebagai **CLIENT** yang terhubung ke port yang sudah dibuka oleh Cooja.

---

## Langkah 1: Modifikasi Kode `mqtt-client.c`

(Bagian ini berisi detail perubahan pada topik, interval, payload, callback, dan perbaikan kompilasi untuk file `/home/syahril/contiki-ng/examples/mqtt-client/mqtt-client.c`)

- **Interval Publish:** Ubah `DEFAULT_PUBLISH_INTERVAL` menjadi `(10 * CLOCK_SECOND)`.
- **Include:** Tambahkan `#include <stdlib.h>` untuk fungsi `rand()`.
- **Topik:** Ubah `construct_pub_topic` menjadi `contiki/sensor/data` dan `construct_sub_topic` menjadi `contiki/actuator/command`.
- **Payload:** Sederhanakan fungsi `publish()` untuk mengirim JSON `{"sensor_value": ..., "seq": ...}`.
- **Callback:** Ubah fungsi `pub_handler()` untuk memproses perintah di topik `contiki/actuator/command`.
- **Kompilasi:** Hapus fungsi `ipaddr_sprintf()` yang tidak terpakai.
- **Logging:** Ganti makro `LOG_INFO` dengan `printf()` di dalam fungsi `publish` dan `pub_handler` untuk memastikan output debug selalu terlihat di Cooja, terlepas dari konfigurasi level log.

---

## Langkah 2: Kompilasi Firmware

1.  **Compile Border Router:**
    ```bash
    cd ~/contiki-ng/examples/rpl-border-router
    make TARGET=cooja
    ```

2.  **Compile MQTT Client (yang sudah dimodifikasi):**
    ```bash
    cd ~/contiki-ng/examples/mqtt-client
    make clean && make TARGET=cooja
    ```

---

## Langkah 3: Menjalankan Simulasi & Jaringan (Alur Presisi)

Urutan ini **sangat penting** untuk menghindari masalah koneksi.

1.  **Jalankan Broker MQTT:** (Di terminal 1)
    Biarkan terminal ini berjalan.

    > **Catatan Penting:** Jika terdapat error saat menjalankan mosquitto broker, tambahkan konfigurasi :Buat file misal : contiki.conf di lokasi /etc/mosquitto/conf.d/ dengan menambahkan isi file sebagai berikut:
    > ```ini
    > listener 1883
    > allow_anonymous true
    > log_type all
    > connection_messages true
    > log_timestamp true
    > ```

    ```bash
    # Hentikan service default untuk mencegah konflik
    sudo systemctl stop mosquitto
    # Jalankan secara manual dengan config khusus untuk log detail
    sudo /usr/sbin/mosquitto -v -c /etc/mosquitto/conf.d/contiki.conf
    ```

2.  **Siapkan Cooja & Buka Port Server:**
    - Buka Cooja, siapkan simulasi dengan 1 mote **Border Router** dan 1 mote **MQTT Client**.
    - **JANGAN KLIK START SIMULASI DULU** (tombol play).
    - Klik kanan pada mote **Border Router (ID:1)** -> `Mote tools for Mote 1` -> `Serial Socket (SERVER)`.
    - Di jendela yang muncul, klik **`Start`**. Sekarang Cooja (sebagai Server) sedang menunggu koneksi di port 60001, meskipun simulasi utama masih dijeda.

3.  **Jalankan `tunslip6` sebagai Client:** (Di terminal 2)
    Setelah server di Cooja siap, jalankan perintah ini. `tunslip6` akan terhubung ke Cooja.
    ```bash
    sudo ~/contiki-ng/tools/serial-io/tunslip6 -L -v -a 127.0.0.1 fd00::1/64
    ```

4.  **Mulai Simulasi:**
    - Kembali ke jendela utama Cooja.
    - Sekarang, klik tombol **`Start`** (tombol play) untuk memulai simulasi. Mote akan boot dengan semua koneksi jaringan sudah siap.

---

## Langkah 4: Verifikasi & Pengujian

1.  **Lihat Log:** Log Border Router di Cooja akan langsung mendapatkan alamat `fd00::...` tanpa pesan `Waiting for prefix` yang berulang. Di Mote Output MQTT Client, Anda akan melihat pesan `Just Published...` dari `printf`.

2.  **Tes Koneksi:** (Di terminal 3)
    ```bash
    ping fd00::201:1:1:1
    ```

3.  **Tes MQTT:** (Di terminal 3 atau 4)
    - Dapatkan data dari sensor:
      ```bash
      mosquitto_sub -h fd00::1 -t "contiki/sensor/data" -v
      ```
    - Kirim perintah ke LED (dan lihat output `printf` di Mote Output Cooja):
      ```bash
      mosquitto_pub -h fd00::1 -t "contiki/actuator/command" -m "1"
      ```