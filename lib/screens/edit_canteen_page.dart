import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/canteen_model.dart';
import 'package:provider/provider.dart';

// --- NAMA CLASS HARUS 'EditCanteenPage' ---
class EditCanteenPage extends StatefulWidget {
  final Canteen canteenToEdit;
  const EditCanteenPage({super.key, required this.canteenToEdit});

  @override
  // --- NAMA STATE HARUS '_EditCanteenPageState' ---
  State<EditCanteenPage> createState() => _EditCanteenPageState();
}

class _EditCanteenPageState extends State<EditCanteenPage> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Masih pakai URL

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.canteenToEdit.name;
    _locationController.text = widget.canteenToEdit.location;
    _imageUrlController.text = widget.canteenToEdit.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateCanteen() {
    if (_formKey.currentState!.validate()) {
      final updatedCanteen = Canteen(
        name: _nameController.text,
        location: _locationController.text,
        imageUrl: _imageUrlController.text,
        menus: widget.canteenToEdit.menus,
      );

      context.read<CanteenModel>().updateCanteen(
        widget.canteenToEdit,
        updatedCanteen,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${updatedCanteen.name} berhasil diperbarui!')),
      );

      Navigator.pop(context);
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