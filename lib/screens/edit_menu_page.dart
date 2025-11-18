import 'package:flutter/material.dart';
import 'package:kanhas/helpers/image_helper.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/canteen_model.dart';
import 'package:kanhas/widgets/local_or_network_image.dart';
import 'package:provider/provider.dart';

class EditMenuPage extends StatefulWidget {
  final Canteen canteen;
  final Menu menuToEdit;
  const EditMenuPage(
      {super.key, required this.canteen, required this.menuToEdit});

  @override
  State<EditMenuPage> createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  String? _pickedImagePath;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.menuToEdit.name;
    _priceController.text = widget.menuToEdit.price.toString();
    _descController.text = widget.menuToEdit.description;
    _pickedImagePath = widget.menuToEdit.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
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

  void _updateMenu() {
    if (_formKey.currentState!.validate() && _pickedImagePath != null) {
      final updatedMenu = Menu(
        name: _nameController.text,
        price: int.parse(_priceController.text),
        description: _descController.text,
        imageUrl: _pickedImagePath!,
      );

      context.read<CanteenModel>().updateMenuInCanteen(
            widget.canteen,
            widget.menuToEdit,
            updatedMenu,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedMenu.name} berhasil diperbarui!'),
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
        title: Text('Edit ${widget.menuToEdit.name}'),
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
                controller: _priceController,
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
                controller: _descController,
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
              const Text('Gambar Menu:', style: TextStyle(fontSize: 16)),
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
                            errorIcon: Icons.fastfood,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateMenu,
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
