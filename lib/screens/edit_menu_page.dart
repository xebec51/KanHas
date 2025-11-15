import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/canteen_model.dart';
import 'package:provider/provider.dart';

class EditMenuPage extends StatefulWidget {
  // 1. Kita perlu tahu kantin & menu mana yang akan diedit
  final Canteen canteen;
  final Menu menuToEdit;
  const EditMenuPage({super.key, required this.canteen, required this.menuToEdit});

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  // 2. Buat controller
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // 3. INI BAGIAN PENTING: initState
  // Kita isi controller dengan data menu yang 'lama'
  // saat halaman pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.menuToEdit.name;
    _priceController.text = widget.menuToEdit.price.toString();
    _descController.text = widget.menuToEdit.description;
    _imageUrlController.text = widget.menuToEdit.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateMenu() {
    // 5. Validasi form
    if (_formKey.currentState!.validate()) {
      // 6. Buat objek Menu BARU dari input
      final updatedMenu = Menu(
        name: _nameController.text,
        price: int.parse(_priceController.text),
        description: _descController.text,
        imageUrl: _imageUrlController.text,
      );

      // 7. Panggil provider untuk 'update'
      // (Kita akan buat fungsi ini di Aksi 2)
      context.read<CanteenModel>().updateMenuInCanteen(
        widget.canteen,
        widget.menuToEdit, // Kirim menu lama
        updatedMenu,        // Kirim menu baru
      );

      // 8. Tampilkan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${updatedMenu.name} berhasil diperbarui!')),
      );

      // 9. Kembali ke halaman sebelumnya (MenuPage)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.menuToEdit.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController, // Sudah terisi otomatis
                decoration: const InputDecoration(
                  labelText: 'Nama Menu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama menu tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController, // Sudah terisi otomatis
                decoration: const InputDecoration(
                  labelText: 'Harga Menu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController, // Sudah terisi otomatis
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Menu',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _imageUrlController, // Sudah terisi otomatis
                decoration: const InputDecoration(
                  labelText: 'URL Gambar Menu',
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

              ElevatedButton(
                onPressed: _updateMenu, // Panggil fungsi update
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