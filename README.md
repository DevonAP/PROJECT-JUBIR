# JUBIR - Aplikasi Komunikasi Inklusif (AAC)

JUBIR adalah aplikasi Augmentative and Alternative Communication (AAC) berbasis Offline-First yang dirancang dengan performa tinggi (Zero Latency). Proyek ini dibangun menggunakan Flutter dengan fokus pada prinsip Interaksi Manusia dan Komputer (IMK) untuk membantu penyandang disabilitas (tuli, bisu, atau gangguan wicara) dalam berkomunikasi dengan lancar dan responsif.

## Fitur Utama

* **Zero Latency & Offline-First:** Seluruh pemrosesan (prediksi kata & Text-to-Speech) berjalan secara lokal di perangkat tanpa membutuhkan koneksi internet.
* **Prediksi Kata Cerdas (N-Gram):** Menampilkan 6 rekomendasi kosakata secara real-time setiap kali pengguna mengetik, beradaptasi dengan konteks kalimat.
* **Pemrosesan Paralel (Isolates):** Menjalankan algoritma N-Gram dan pemutaran suara TTS di latar belakang tanpa menyebabkan antarmuka (UI) lag atau terhenti (freeze).
* **Desain Inklusif (HCI/IMK):** Menerapkan Hukum Fitts (Fitts's Law) untuk penempatan tombol prediksi di area jangkauan jempol dan meminimalkan beban kognitif dengan antarmuka yang minimalis.

## Teknologi Utama

* **Framework:** Flutter & Dart
* **State Management:** Riverpod (Untuk pembaruan UI instan pada 6 tombol prediksi)
* **Database Lokal:** Hive (NoSQL Key-Value untuk pembacaan kamus data di bawah 5 milidetik)
* **Concurrency:** Dart Isolates (Multi-threading untuk pemrosesan latar belakang)

## Struktur Arsitektur (Feature-First)

Proyek ini menggunakan pendekatan Clean Architecture berbasis fitur agar mudah dikelola:

```
lib/
 ┣ core/                # Konfigurasi dasar (tema, warna, font, konstanta)
 ┣ features/            # Fitur inti aplikasi
 ┃ ┣ keyboard_input/    # UI area teks besar & logika pengetikan
 ┃ ┣ word_prediction/   # Pembacaan database Hive & UI 6 tombol prediksi
 ┃ ┗ tts_voice/         # Eksekusi AI Text-to-Speech via Isolates
 ┗ main.dart            # Entry point aplikasi

```

## Prasyarat Sistem

* Flutter SDK (Versi >= 3.22.0)
* Dart SDK (Versi >= 3.4.0)
* Android Studio / VS Code dengan Ekstensi Flutter & Dart
* Perangkat fisik (Smartphone Android/iOS) direkomendasikan untuk pengujian performa

## Langkah Instalasi

1. Clone repositori ini ke dalam mesin lokal Anda:
git clone [https://github.com/username/jubir.git](https://www.google.com/search?q=https://github.com/username/jubir.git)
2. Masuk ke dalam direktori proyek:
cd jubir
3. Unduh seluruh dependensi yang dibutuhkan:
flutter pub get
4. Jalankan code generation untuk mengonfigurasi Hive dan Riverpod:
flutter pub run build_runner build --delete-conflicting-outputs
5. Jalankan aplikasi ke emulator atau perangkat target:
flutter run

## Desain Antarmuka & Interaksi (IMK)

* **Akurasi Tata Letak:** Keyboard modern berada di posisi terbawah. Tepat di atasnya terdapat grid 6 tombol prediksi berbentuk *rounded rectangular* dan satu tombol *backspace* di sisi kiri.
* **Area Fokus Utama:** Area teks statis berukuran besar dengan tipografi tingkat keterbacaan tinggi (high legibility) berada di tengah. Tombol aksi utama (FAB Speaker) berada di kanan dengan ukuran mencolok.
* **Palet Warna:** Menggunakan warna latar belakang pastel yang lembut untuk memberikan efek menenangkan, dipadukan dengan warna primer kontras tinggi pada tombol FAB agar mudah dikenali.

## Pembagian Tugas Pengembang

* **Front-End & UI Developer:** Bertanggung jawab pada folder `view/`. Menerjemahkan desain menjadi antarmuka Flutter, mengatur animasi transisi yang mulus, dan mengelola interaksi visual pengguna.
* **Back-End Lokal, Data & AI Developer:** Bertanggung jawab pada folder `controller/`, `repository/`, dan `service/`. Mengonfigurasi skema penyimpanan Hive, membangun logika Riverpod, serta mengatur pemrosesan data paralel melalui Isolates.