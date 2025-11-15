import 'package:flutter/material.dart';
import 'package:kanhas/models/user_model.dart'; // Impor model user kita

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Cek jika username sudah ada
    bool userExists = userList.any((user) => user.username == username);

    if (userExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Username sudah terdaftar!'),
        ),
      );
    } else {
      // Tambah user baru ke list
      userList.add(
        User(
          username: username,
          password: password,
          role: UserRole.mahasiswa, // <-- Hanya bisa daftar sebagai MAHASISWA
        ),
      );

      // Tampilkan sukses dan kembali ke Login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          // --- INI PERBAIKANNYA ---
          backgroundColor: Colors.green, // Pakai titik (.), bukan titik dua (:)
          content: Text('Registrasi berhasil! Silakan login.'),
        ),
      );
      Navigator.pop(context); // Kembali ke LoginPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol Back manual
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 20),
                Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                Text(
                  'Daftar sebagai Mahasiswa', // Tambahkan sub-judul
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),

                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username Baru',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password Baru',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Daftar', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}