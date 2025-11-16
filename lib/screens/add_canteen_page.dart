import 'dart:io'; // <-- Impor untuk 'File'
import 'package:flutter/material.dart';
import 'package:kanhas/helpers/image_helper.dart'; // <-- Impor helper kita
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/canteen_model.dart';
import 'package:provider/provider.dart';

// --- NAMA CLASS HARUS 'AddCanteenPage' ---
class AddCanteenPage extends StatefulWidget {
  const AddCanteenPage({super.key});

  @override
  // --- NAMA STATE HARUS '_AddCanteenPageState' ---
  State<AddCanteenPage> createState() => _AddCanteenPageState();
}

class _AddCanteenPageState extends State<AddCanteenPage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  // State untuk menyimpan path file
  String? _pickedImagePath;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final String? imagePath = await ImageHelper.pickAndSaveImage();
    if (imagePath != null) {
      setState(() {
        _pickedImagePath = imagePath;
      });
    }
  }

  void _saveCanteen() {
    // Validasi form (termasuk cek gambar)
    if (_formKey.currentState!.validate() && _pickedImagePath != null) {
      final newCanteen = Canteen(
        name: _nameController.text,
        location: _locationController.text,
        imageUrl: _pickedImagePath!, // Simpan path file lokal
        menus: [],
      );

      context.read<CanteenModel>().addCanteen(newCanteen);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newCanteen.name} berhasil ditambahkan!')),
      );

      Navigator.pop(context);
    } else if (_pickedImagePath == null) {
      // Tampilkan error jika gambar kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih gambar kantin terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kantin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kantin tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
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

              // UI UNTUK IMAGE PICKER
              const Text('Gambar Kantin:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickImage, // Panggil fungsi pilih gambar
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _pickedImagePath == null
                  // Tampilan jika gambar BELUM dipilih
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo,
                          color: Colors.grey, size: 50),
                      SizedBox(height: 8),
                      Text('Ketuk untuk pilih gambar'),
                    ],
                  )
                  // Tampilan jika gambar SUDAH dipilih
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(_pickedImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // ------------------------------------

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveCanteen,
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