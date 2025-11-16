import 'dart:io'; // <-- Impor untuk 'File'
import 'package:flutter/material.dart';
import 'package:kanhas/helpers/image_helper.dart'; // <-- Impor helper kita
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/canteen_model.dart';
import 'package:kanhas/widgets/local_or_network_image.dart'; // <-- Impor widget 'pintar'
import 'package:provider/provider.dart';

class EditCanteenPage extends StatefulWidget {
  final Canteen canteenToEdit;
  const EditCanteenPage({super.key, required this.canteenToEdit});

  @override
  State<EditCanteenPage> createState() => _EditCanteenPageState();
}

class _EditCanteenPageState extends State<EditCanteenPage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  // HAPUS: _imageUrlController
  // GANTI DENGAN: State untuk menyimpan path file
  String? _pickedImagePath;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Isi controller dengan data 'lama'
    _nameController.text = widget.canteenToEdit.name;
    _locationController.text = widget.canteenToEdit.location;

    // Simpan path gambar yang lama ke state
    _pickedImagePath = widget.canteenToEdit.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // --- FUNGSI BARU UNTUK MEMILIH GAMBAR ---
  Future<void> _pickImage() async {
    final String? imagePath = await ImageHelper.pickAndSaveImage();
    if (imagePath != null) {
      setState(() {
        _pickedImagePath = imagePath;
      });
    }
  }

  void _updateCanteen() {
    // Validasi form (gambar tidak wajib di-update)
    if (_formKey.currentState!.validate() && _pickedImagePath != null) {
      // Buat objek Canteen BARU
      final updatedCanteen = Canteen(
        name: _nameController.text,
        location: _locationController.text,
        imageUrl: _pickedImagePath!, // <-- Simpan path (bisa lama atau baru)
        menus: widget.canteenToEdit.menus,
      );

      context.read<CanteenModel>().updateCanteen(
        widget.canteenToEdit,
        updatedCanteen,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${updatedCanteen.name} berhasil diperbarui!')),
      );

      Navigator.pop(context); // Kembali ke HomePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.canteenToEdit.name}'),
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
                validator: (value) { /* ... (validator sama) ... */
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
                validator: (value) { /* ... (validator sama) ... */
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // --- UI BARU UNTUK IMAGE PICKER ---
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
                      ? const Column( /* ... (Tampilan 'pilih gambar') ... */
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: Colors.grey, size: 50),
                      SizedBox(height: 8),
                      Text('Ketuk untuk pilih gambar'),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    // Gunakan widget 'pintar' kita untuk menampilkan
                    // gambar yang ada (lokal atau web)
                    child: LocalOrNetworkImage(
                      imageUrl: _pickedImagePath!,
                      height: 200,
                      width: double.infinity,
                      errorIcon: Icons.store,
                    ),
                  ),
                ),
              ),
              // ------------------------------------

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateCanteen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}