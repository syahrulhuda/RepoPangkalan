# Panduan Membuat Aplikasi Android Baru dengan Firebase Google Sign-In (via Credential Manager API) Menggunakan Bantuan AI

**Tujuan:** Membuat aplikasi Android baru yang mengimplementasikan fungsionalitas login dan logout menggunakan Google Sign-In melalui Credential Manager API dan Firebase Authentication.

## Langkah 1: Penyiapan Proyek Android Baru (Manual)

1.  Buka Android Studio dan buat proyek Android baru (misalnya, "Empty Activity" atau "Empty Compose Activity").
2.  Pilih bahasa Kotlin.

## Langkah 2: Konfigurasi Firebase (Manual)

1.  **Setup Proyek Firebase:**
    *   Buka konsol Firebase dan buat proyek baru atau gunakan yang sudah ada.
    *   Tambahkan aplikasi Android Anda ke proyek Firebase tersebut. Ikuti instruksi di konsol Firebase.
    *   **Penting:** Di bagian "Authentication" pada konsol Firebase, aktifkan Google sebagai metode masuk (Sign-in method).
    *   **Download `google-services.json`:** Setelah mengaktifkan Google Sign-In, unduh file `google-services.json` yang diperbarui. File ini akan berisi informasi klien OAuth yang diperlukan untuk Google Sign-In.
    *   **Pindahkan `google-services.json`:** Letakkan file `google-services.json` di direktori `app/` proyek Android Studio Anda.

## Langkah 3: Tambahkan Dependensi Gradle (Gunakan AI)

1.  **Prompt untuk AI:**
    ```
    Saya sedang membuat aplikasi Android baru. Saya ingin mengimplementasikan Firebase Google Sign-In menggunakan Credential Manager API. Bisakah Anda membantu saya menambahkan semua dependensi yang diperlukan ke file `app/build.gradle.kts` saya? Pastikan untuk menyertakan Firebase Authentication, Credential Manager, dan Coroutines.
    ```
2.  **Terapkan Perubahan:** Setelah AI memberikan kode `app/build.gradle.kts` yang dimodifikasi, salin dan tempel ke file Anda.
3.  **Sinkronkan Gradle:** Sinkronkan proyek Gradle Anda di Android Studio.

## Langkah 4: Konfigurasi `res/values/strings.xml` (Manual)

1.  **Tambahkan `default_web_client_id`:**
    *   Buka file `app/src/main/res/values/strings.xml`.
    *   Tambahkan string berikut, ganti `ID_KLIEN_WEB_ANDA` dengan nilai `client_id` dari tipe `oauth_client` yang memiliki `client_type` "3" (web) di file `google-services.json` Anda.
        ```xml
        <string name="default_web_client_id">ID_KLIEN_WEB_ANDA.apps.googleusercontent.com</string>
        ```
        *Contoh:* Jika di `google-services.json` ada `"client_id": "914450491339-xxxxxxxxxxxx.apps.googleusercontent.com"`, maka `ID_KLIEN_WEB_ANDA` adalah `914450491339-xxxxxxxxxxxx`.

## Langkah 5: Implementasi `MainActivity.kt` (Gunakan AI)

1.  **Prompt untuk AI:**
    ```
    Saya ingin mengimplementasikan Firebase Google Sign-In menggunakan Credential Manager API di `MainActivity.kt` saya. Bisakah Anda membuatkan kode Kotlin lengkap untuk `MainActivity.kt`?

    Kode ini harus:
    - Menginisialisasi Firebase Authentication dan Credential Manager.
    - Menggunakan `CoroutineScope` untuk operasi asinkron.
    - Memiliki fungsi `signInWithGoogle()` yang menggunakan Credential Manager API (`GetGoogleIdOption.Builder()`) untuk mendapatkan ID token Google.
    - Memiliki fungsi `firebaseAuthWithGoogle(idToken: String)` untuk mengautentikasi Firebase dengan ID token Google.
    - Memiliki fungsi `signOut()` yang keluar dari Firebase dan menghapus status kredensial dari Credential Manager.
    - Menampilkan UI sederhana dengan tombol "Sign In with Google" dan "Sign Out", serta menampilkan nama pengguna atau email jika sudah login.
    - Menangani potensi kesalahan dengan `Toast` atau `Log`.
    ```
2.  **Terapkan Perubahan:** Setelah AI memberikan kode `MainActivity.kt` yang lengkap, salin dan tempel ke file Anda.

## Langkah 6: Bangun dan Uji Aplikasi (Manual)

1.  **Clean Project:** Di Android Studio, pilih `Build > Clean Project`.
2.  **Rebuild Project:** Pilih `Build > Rebuild Project`.
3.  **Jalankan Aplikasi:** Jalankan aplikasi di emulator atau perangkat fisik Anda dan uji fungsionalitas Google Sign-In dan Sign-Out.
