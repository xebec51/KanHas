import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kanhas/helpers/image_helper.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/canteen_model.dart';
import 'package:kanhas/widgets/local_or_network_image.dart';
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

  String? _pickedImagePath;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.canteenToEdit.name;
    _locationController.text = widget.canteenToEdit.location;
    _pickedImagePath = widget.canteenToEdit.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final String? imagePath = await ImageHelper.pickAndSaveImage();
    if (imagePath != null) {
      setState(() {
        _pickedImagePath = imagePath;
      });
    }
  }

  void _updateCanteen() {
    if (_formKey.currentState!.validate() && _pickedImagePath != null) {
      final updatedCanteen = Canteen(
        name: _nameController.text,
        location: _locationController.text,
        imageUrl: _pickedImagePath!,
        menus: widget.canteenToEdit.menus,
      );

      context.read<CanteenModel>().updateCanteen(
        widget.canteenToEdit,
        updatedCanteen,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedCanteen.name} berhasil diperbarui!'),
          backgroundColor: Colors.green, // Tambahkan warna sukses
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
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
              const Text('Gambar Kantin:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _pickedImagePath == null
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo,
                          color: Colors.grey, size: 50),
                      SizedBox(height: 8),
                      Text('Ketuk untuk pilih gambar'),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LocalOrNetworkImage(
                      imageUrl: _pickedImagePath!,
                      height: 200,
                      width: double.infinity,
                      errorIcon: Icons.store,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateCanteen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Simpan Perubahan',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}