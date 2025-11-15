import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/canteen_model.dart';
import 'package:provider/provider.dart';

// 1. Buat sebagai StatefulWidget
// Kita perlu ini untuk mengelola state dari form (TextController)
class AddCanteenPage extends StatefulWidget {
  const AddCanteenPage({super.key});

  @override
  State<AddCanteenPage> createState() => _AddCanteenPageState();
}

class _AddCanteenPageState extends State<AddCanteenPage> {
  // 2. Buat controller untuk setiap field
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();

  // 3. Buat GlobalKey untuk Form
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // 4. Jangan lupa dispose controller
    _nameController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveCanteen() {
    // 5. Validasi form
    if (_formKey.currentState!.validate()) {
      // 6. Buat objek Canteen baru dari input
      final newCanteen = Canteen(
        name: _nameController.text,
        location: _locationController.text,
        imageUrl: _imageUrlController.text,
        menus: [], // Kantin baru belum punya menu
      );

      // 7. Panggil provider untuk menambahkan kantin
      context.read<CanteenModel>().addCanteen(newCanteen);

      // 8. Tampilkan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newCanteen.name} berhasil ditambahkan!')),
      );

      // 9. Kembali ke halaman sebelumnya (HomePage)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kantin Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 10. Bungkus dengan Form
        child: Form(
          key: _formKey, // Hubungkan GlobalKey
          child: ListView( // Pakai ListView agar bisa di-scroll
            children: [
              // 11. TextFormField untuk Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kantin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
                // 12. Tambahkan validasi
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kantin tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 13. TextFormField untuk Lokasi
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Lokasi Kantin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 14. TextFormField untuk URL Gambar
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar Kantin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL Gambar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // 15. Tombol Simpan
              ElevatedButton(
                onPressed: _saveCanteen, // Panggil fungsi simpan
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Simpan Kantin', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}