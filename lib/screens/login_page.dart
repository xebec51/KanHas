import 'package:flutter/material.dart';
import 'package:kanhas/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Logic controller (TETAP SAMA)
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Logic login (TETAP SAMA)
  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'mahasiswa' && password == '123') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(role: 'Mahasiswa'),
        ),
      );
    }
    else if (username == 'admin' && password == '123') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(role: 'Admin'),
        ),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Username atau Password Salah!'),
        ),
      );
    }
  }

  // --- BUILD METHOD YANG DIROMBAK TOTAL ---
  @override
  Widget build(BuildContext context) {
    // 1. HAPUS AppBar, GANTI DENGAN Scaffold + SafeArea
    return Scaffold(
      // SafeArea menghindari konten menabrak status bar (jam, baterai)
      body: SafeArea(
        child: SingleChildScrollView(
          // 2. Beri padding yang lebih besar di sisi-sisinya
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              // 3. Ratakan konten ke kiri, bukan di tengah
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 4. JUDUL BESAR (Branding & Typography)
                const SizedBox(height: 60), // Beri jarak dari atas
                Text(
                  'Selamat Datang\ndi Kanhas',
                  // Gunakan style teks yang kuat
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700], // Warna merah tema kita
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Login untuk melanjutkan pesananmu.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 50), // Jarak ke form

                // --- FORM LOGIN (Kodenya sama seperti sebelumnya) ---
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Masukkan username Anda',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password Anda',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

                const SizedBox(height: 40), // Jarak ke tombol

                // --- TOMBOL LOGIN (Kodenya sama seperti sebelumnya) ---
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Pastikan tombol juga merah
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 30), // Jarak ke link bawah

                // 5. LINK "DAFTAR" (Pelengkap UI)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () {
                        // Belum berfungsi, tapi ini untuk UI
                      },
                      child: const Text(
                        'Daftar di sini',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}