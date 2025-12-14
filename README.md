# Kanhas (Aplikasi Pemesanan Kantin)

**Kanhas** adalah aplikasi pemesanan kantin (Canteen Ordering) yang dibangun menggunakan Flutter. Aplikasi ini dibuat sebagai proyek akhir untuk kelas "Belajar Membuat Aplikasi Flutter untuk Pemula" di Dicoding, dengan banyak fitur tambahan untuk menyempurnakan fungsionalitas dan UI/UX.

Aplikasi ini mengimplementasikan manajemen state menggunakan `provider`, autentikasi lokal, pemisahan peran (Admin & Mahasiswa), dan fungsionalitas CRUD penuh, termasuk unggah gambar lokal.

![Contoh Tampilan Aplikasi Kanhas](https://via.placeholder.com/800x400.png?text=Sangat+Disarankan+Masukkan+GIF+atau+Mockup+Aplikasi+Anda+di+Sini)

---

## 🚀 Fitur Utama

Aplikasi ini memiliki dua peran pengguna yang berbeda (Admin dan Mahasiswa) dengan fitur yang disesuaikan.

### 👨‍🎓 Fitur Mahasiswa
* **Autentikasi:** Login dan Register (akun disimpan secara lokal).
* **Navigasi:** Bottom Navigation Bar untuk berpindah antar halaman (Home, Cart, Profile).
* **Jelajah Kantin:** Melihat daftar kantin dengan fitur **Pencarian** (Search).
* **Jelajah Menu:** Melihat daftar menu per kantin dengan fitur **Pencarian** dan **Filter Kategori** (Nasi, Minuman, dll).
* **Detail Menu:** Melihat detail deskripsi menu dengan **Hero Animation** dan desain `SliverAppBar` yang dinamis.
* **Keranjang Belanja:** Menambah, mengurangi, dan menghapus item dari keranjang (`CartModel`).
* **Checkout:** Menyelesaikan pesanan, yang akan mengosongkan keranjang.
* **Riwayat Pesanan:** Melihat daftar semua pesanan yang telah berhasil di-*checkout* (`OrderHistoryModel`).
* **Profil Kompleks:**
    * Melihat info profil (Nama Lengkap, Email, Role).
    * **Mengganti Foto Profil** dari galeri.
    * **Edit Info Profil** (Nama Lengkap & Email).
    * **Ubah Password** (memvalidasi password lama).

### ⚙️ Fitur Admin
* Memiliki semua fitur Mahasiswa.
* **CRUD Kantin:**
    * Menambah kantin baru dengan **unggah gambar lokal**.
    * Mengedit info kantin (termasuk mengganti gambar).
    * Menghapus kantin.
* **CRUD Menu:**
    * Menambah menu baru di kantin tertentu dengan **unggah gambar lokal**.
    * Mengedit info menu (termasuk mengganti gambar).
    * Menghapus menu.

---

## 🛠️ Arsitektur & Teknologi

* **Framework:** Flutter 3.x
* **State Management:** `provider` (menggunakan `MultiProvider` untuk `CanteenModel`, `CartModel`, dan `OrderHistoryModel`).
* **Image Handling:**
    * `image_picker`: Untuk mengambil gambar dari galeri.
    * `path_provider`: Untuk menyimpan dan mengambil gambar dari direktori lokal aplikasi.
* **Navigasi:** `Navigator` 2.0 (standar) dengan `pushAndRemoveUntil` untuk alur autentikasi.
* **UI/UX:**
    * `SliverAppBar` untuk detail halaman yang dinamis.
    * `Hero Animation` untuk transisi gambar yang mulus.
    * `SnackBarBehavior.floating` untuk notifikasi yang tidak menutupi UI.
    * `SingleChildScrollView` & `GridView` untuk layout yang responsif dan bebas *overflow*.
* **Data:** Data disimpan secara *runtime* (dalam memori) pada *list* global. **(Catatan: Data akan reset setiap kali aplikasi ditutup).**

---

## 🏃 Cara Menjalankan Proyek

1.  Pastikan Anda memiliki Flutter SDK yang terinstal.
2.  Clone repositori ini:
    ```bash
    git clone [URL_GITHUB_ANDA]
    ```
3.  Masuk ke direktori proyek:
    ```bash
    cd kanhas
    ```
4.  Dapatkan *dependencies*:
    ```bash
    flutter pub get
    ```
5.  Jalankan aplikasi:
    ```bash
    flutter run
    ```

### 🔐 Akun Demo

Anda dapat menggunakan akun berikut untuk menguji aplikasi:

* **Akun Admin:**
    * **Username:** `admin`
    * **Password:** `admin123`

* **Akun Mahasiswa:**
    * **Username:** `mahasiswa`
    * **Password:** `siswa123`

* Atau **buat akun baru** melalui halaman Registrasi (otomatis akan mendapat peran Mahasiswa).
