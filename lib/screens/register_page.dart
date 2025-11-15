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

  // State untuk menyimpan role yang dipilih
  UserRole _selectedRole = UserRole.mahasiswa;

  void _register() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Cek jika username sudah ada
    bool userExists = userList.any((user) => user.username == username);

    if (userExists) {
      // Tampilkan error jika user sudah ada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Username sudah terdaftar!'),
        ),
      );
    } else {
      // Tambah user baru ke list
      userList.add(
        User(username: username, password: password, role: _selectedRole),
      );

      // Tampilkan sukses dan kembali ke Login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
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
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
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
                const SizedBox(height: 20),

                // PILIHAN ROLE (Radio Button)
                const Text('Daftar sebagai:', style: TextStyle(fontSize: 16)),
                RadioListTile<UserRole>(
                  title: const Text('Mahasiswa'),
                  value: UserRole.mahasiswa,
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
                RadioListTile<UserRole>(
                  title: const Text('Admin'),
                  value: UserRole.admin,
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
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