**PANDUAN INSTALASI LENGKAP GEMINI CLI DI WINDOWS: DARI NOL HINGGA
MASTER**

A.  DISCLAIMER!

1.  Komputer atau Laptop dengan sistem operasi Windows.

2.  Koneksi Internet.

3.  Akun Google (akun Gmail Anda sudah cukup).

4.  Sudah terinstall python.


B.  Bagian 1: Mempersiapkan \"Kunci\" Rahasia Anda (API Key)

1.  Buka browser Anda (Google Chrome, Firefox, dll).

2.  Kunjungi situs Google AI Studio: <https://aistudio.google.com/>

3.  Login menggunakan akun Google Anda jika diminta.

4.  Setelah masuk, cari dan klik tombol **\"Get API key\"** di sisi kiri
    halaman.

5.  Sebuah jendela akan muncul. Klik tombol biru bertuliskan **\"Create
    API key in new project\"**.

6.  *Cling!* Sebuah kode rahasia yang panjang akan muncul. Ini adalah
    kunci Anda.

7.  **SANGAT PENTING:** Klik ikon \"copy\" (gambar dua lembar kertas) di
    sebelah kanan kode tersebut. Buka aplikasi **Notepad** di komputer
    Anda, lalu **tempel (paste)** kunci tersebut di sana. Simpan dulu
    Notepad ini, jangan ditutup. Kita akan membutuhkannya nanti.


C.  Bagian 2: Mempersiapkan \"Rumah\" untuk Remote Control Kita

1.  **Buka Terminal PowerShell.** Caranya: Tekan tombol **Windows** di
    keyboard Anda, ketik PowerShell, lalu klik aplikasi \"Windows
    PowerShell\" yang muncul.

2.  Kita perlu tahu nama folder pengguna Anda. Di jendela PowerShell
    yang baru terbuka, ketik perintah: \[whoami\] ini lalu tekan
    **Enter**. Outputnya akan seperti namakomputer\namaanda. namaanda
    itulah username Anda.

3.  Sekarang, buat folder \"rumahnya\" dengan mengetik perintah di bawah
    ini. Ganti NAMA_ANDA dengan username Anda yang sebenarnya.

4.  Terakhir, mari kita masuk ke \"rumah\" baru tersebut. Ketik perintah
    cd (artinya *change directory*) di bawah ini (ingat, ganti
    NAMA_ANDA): mkdir C:\Users\NAMA_ANDA\scripts

5.  Tekan **Enter**. Sekarang kita siap untuk mulai merakit.


D.  Bagian 3: Merakit Komponen Inti Remote (Menulis Kode Python)

1.  Di jendela PowerShell (pastikan Anda masih di dalam folder scripts),
    ketik perintah ini untuk membuat file kosong: New-Item gemini.py. Lalu, tekan **Enter**. Sebuah file bernama gemini.py kini telah dibuat didalam folder scripts Anda.

2.  Buka **File Explorer**, navigasi ke folder scripts Anda
    (C:\Users\NAMA_ANDA\scripts). Anda akan melihat file gemini.py di
    sana.

3.  Klik kanan pada file gemini.py, pilih Open with -\> Notepad (atau
    editor kode lain seperti Visual Studio Code (VSC) jika punya).

4.  Salin **semua kode** di bawah ini, lalu tempel ke dalam file
    Notepad/VSC yang terbuka.

> \# Ini adalah \"Otak\" dari Remote Control kita
>
> import google.generativeai as genai
>
> import os
>
> import sys
>
> def main():
>
> \# Langkah 1: Mencari Kunci Rahasia
>
> try:
>
> api_key = os.environ\[\"GOOGLE_API_KEY\"\]
>
> genai.configure(api_key=api_key)
>
> except KeyError:
>
> print(\"KESALAHAN: \'Kunci\' Rahasia (GOOGLE_API_KEY) tidak ditemukan
> di sistem Anda.\")
>
> print(\"Mohon pastikan Anda sudah mengikuti Bagian 4 dari panduan.\")
>
> sys.exit(1)
>
> \# Langkah 2: Menginisialisasi Model AI
>
> model = genai.GenerativeModel(\'gemini-1.5-flash\')
>
> \# Langkah 3: Mendengarkan Perintah Anda
>
> prompt = \" \".join(sys.argv\[1:\])
>
> if not prompt:
>
> if not sys.stdin.isatty():
>
> prompt = sys.stdin.read().strip()
>
> else:
>
> print(\"Cara pakai: gemini \'tulis pertanyaan Anda di sini\'\")
>
> sys.exit(1)
>
> \# Langkah 4: Mengirim Perintah ke Otak Raksasa dan Menampilkan
> Jawaban
>
> try:
>
> response = model.generate_content(prompt, stream=True)
>
> for chunk in response:
>
> print(chunk.text, end=\"\", flush=True)
>
> print() \# Memberi baris baru di akhir
>
> except Exception as e:
>
> print(f\"\nOops, terjadi kesalahan saat menghubungi Google: {e}\")
>
> if \_\_name\_\_ == \"\_\_main\_\_\":
>
> main()

5.  Klik File -\> Save di Notepad, lalu tutup. Komponen inti remote kita
    sudah jadi!


E.  Bagian 4: Mengatur Kunci Akses di Sistem (Environment Variable API
    Key)

1.  Tekan tombol **Windows**, ketik env, dan pilih **\"Edit the system
    environment variables\"**.

2.  Klik tombol **\"Environment Variables\...\"**.

3.  Fokus pada **kotak bagian atas** (\"User variables for NAMA_ANDA\").
    Klik tombol **New\...**.

4.  Akan muncul dua kolom:

- **Variable name:** Ketik GOOGLE_API_KEY (harus persis seperti ini).

- **Variable value:** Buka Notepad dari Bagian 1 tadi, salin kunci
  rahasia Anda, dan tempel di sini.

5.  Klik OK.

6.  Sekarang Anda kembali ke jendela sebelumnya. Klik OK lagi.

7.  Dan klik OK sekali lagi di jendela terakhir. Kunci Anda sekarang
    sudah aman tersimpan.


F.  Bagian 5: Mendaftarkan Lokasi Remote ke Sistem (Mengatur PATH)

1.  Ulangi **Langkah 1 & 2** dari Bagian 4 untuk membuka jendela
    \"Environment Variables\".

2.  Di kotak atas (\"User variables\"), cari dan klik variabel bernama
    **Path**, lalu klik tombol **\"Edit\...\"**.

3.  Klik tombol **\"New\"**. Sebuah baris kosong akan muncul.

4.  Ketik path lengkap ke folder scripts Anda. (Contoh:
    C:\Users\NAMA_ANDA\scripts. Ganti NAMA_ANDA dengan username Anda).

5.  Klik OK, OK, dan OK lagi untuk menyimpan dan menutup semua jendela.


G.  Bagian 6: Membuat \"Tombol Ajaib\" di Remote (File .bat)

1.  Buka **File Explorer** lagi dan masuk ke folder scripts Anda.

2.  Klik kanan di area kosong, pilih New \> Text Document.

3.  Beri nama file tersebut **gemini.bat**. Pastikan Anda menghapus .txt
    di akhir. Windows mungkin akan bertanya \"Are you sure you want to
    change it?\", pilih **Yes**.

4.  Klik kanan pada file gemini.bat yang baru, pilih Edit (atau Open
    with \> Notepad).

5.  Salin dan tempel **satu baris** kode di bawah ini ke dalamnya.
    **INGAT GANTI NAMA_ANDA!**

> \>\> @python \"C:\Users\NAMA_ANDA\scripts\gemini.py\" %\*

6.  Klik File -\> Save dan tutup Notepad. Tombol ajaib Anda sudah siap!


H.  Bagian 7: Tes Terakhir dan Kelulusan!

1.  **LANGKAH PALING KRUSIAL DARI SEMUANYA:** **TUTUP SEMUA JENDELA
    POWERSHELL YANG SEDANG TERBUKA, LALU BUKA SATU JENDELA POWERSHELL
    YANG BARU.** Sistem perlu di-restart (dalam hal ini, terminalnya)
    untuk membaca semua pengaturan baru yang sudah kita buat.

2.  Di jendela PowerShell yang baru dan segar, ketik perintah pertama
    Anda. Mari kita tanya sesuatu yang mudah: \[gemini apa saja keunikan
    kota Malang?\]

3.  Tekan **Enter**.

4.  Jika semuanya berjalan lancar, Anda akan melihat jawaban dari Gemini
    muncul langsung di terminal Anda.
