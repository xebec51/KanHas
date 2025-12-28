import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/providers/auth_provider.dart';

class EditInfoPage extends StatefulWidget {
  final User user;
  const EditInfoPage({super.key, required this.user});

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveInfo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Gunakan copyWith yang sudah kita tambahkan di model
    final updatedUser = widget.user.copyWith(
      fullName: _fullNameController.text,
      email: _emailController.text,
    );

    // Panggil Provider untuk simpan perubahan
    await context.read<AuthProvider>().updateUser(updatedUser);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Info profil berhasil diperbarui!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Info Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge_outlined)),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined)),
                validator: (v) => !v!.contains('@') ? 'Email tidak valid' : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveInfo,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50)),
                child: const Text('Simpan Perubahan',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}