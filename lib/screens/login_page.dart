import 'package:flutter/material.dart';

// 1. IMPORT HALAMAN HOME (tujuan setelah login)
// Kita beri 'as home' untuk menghindari konflik nama jika ada
// kelas 'HomePage' di file lain (meskipun sekarang belum ada).
import 'package:kanhas/screens/home_page.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 2. BUAT CONTROLLER
  // Ini adalah "pengontrol" yang akan memegang teks dari TextField.
  // Kita bisa ambil nilai inputnya dari sini.
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // 3. BERSIHKAN CONTROLLER (PENTING)
  // Ini untuk manajemen memori yang baik. Wajib ada di StatefulWidget
  // yang menggunakan controller.
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 4. BUAT FUNGSI UNTUK LOGIKA LOGIN
  void _login() {
    // Ambil teks dari controller
    String username = _usernameController.text;
    String password = _passwordController.text;

    // --- INI LOGIKA LOGIN HARDCODE ANDA ---
    // (Role Mahasiswa)
    if (username == 'mahasiswa' && password == '123') {
      // Navigasi ke HomePage, kirim 'role'
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(role: 'Mahasiswa'),
        ),
      );
    } 
    // (Role Admin)
    else if (username == 'admin' && password == '123') {
      // Navigasi ke HomePage, kirim 'role'
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(role: 'Admin'),
        ),
      );
    } 
    // (Login Gagal)
    else {
      // Tampilkan peringatan jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Username atau Password Salah!'),
        ),
      );
    }
    // ------------------------------------
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selamat Datang di Kanhas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          // Kita bungkus dengan SingleChildScrollView
          // agar tidak 'overflow' saat keyboard muncul
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // 5. GANTI DENGAN TEXTFIELD ASLI
                // --- TEXTFIELD USERNAME ---
                TextField(
                  controller: _usernameController, // Hubungkan controller
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Masukkan username Anda',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person), // Ikon di depan
                  ),
                ),

                const SizedBox(height: 20), // Jarak

                // --- TEXTFIELD PASSWORD ---
                TextField(
                  controller: _passwordController, // Hubungkan controller
                  obscureText: true, // Membuat teks jadi •••• (untuk password)
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password Anda',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock), // Ikon di depan
                  ),
                ),

                const SizedBox(height: 30), // Jarak

                // 6. GANTI DENGAN TOMBOL ASLI
                // --- TOMBOL LOGIN ---
                ElevatedButton(
                  // Panggil fungsi _login saat tombol ditekan
                  onPressed: _login,
                  
                  // Style tombol agar lebih besar
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Lebar penuh, tinggi 50
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}