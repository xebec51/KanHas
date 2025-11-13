import 'package:flutter/material.dart';
// 1. IMPORT DATA MODEL (KITA BUTUH CLASS 'MENU')
import 'package:kanhas/models/canteen_data.dart';

// 2. BUAT SEBAGAI STATEFULWIDGET
// Ini adalah widget utama
class DetailPage extends StatefulWidget {
  
  // 3. DEKLARASIKAN VARIABEL UNTUK MENANGKAP DATA MENU
  final Menu menu;

  // 4. BUAT CONSTRUCTOR UNTUK MENERIMA DATA MENU
  const DetailPage({super.key, required this.menu});

  @Override
  State<DetailPage> createState() => _DetailPageState();
}

// Ini adalah kelas 'State' yang akan menyimpan data
class _DetailPageState extends State<DetailPage> {
  
  // 5. BUAT SEBUAH VARIABEL STATE
  // Ini adalah data yang akan berubah: status 'favorite'
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // 6. TAMPILKAN NAMA MENU DI APPBAR
      appBar: AppBar(
        title: Text(widget.menu.name), // Ambil menu dari 'widget'
        centerTitle: true,
        
        // 7. TAMBAHKAN TOMBOL AKSI (FAVORITE)
        actions: [
          IconButton(
            icon: Icon(
              // 8. LOGIKA UNTUK MENGUBAH IKON
              // Jika 'isFavorite' true, tampilkan ikon penuh
              // Jika false, tampilkan ikon outline
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              // 9. PANGGIL setState() UNTUK MEMPERBARUI TAMPILAN
              // Ini adalah inti dari StatefulWidget
              setState(() {
                // Balikkan nilainya (true jadi false, false jadi true)
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      
      // Bungkus dengan SingleChildScrollView agar deskripsi
      // yang panjang bisa di-scroll dan tidak overflow
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Placeholder untuk gambar (nanti bisa Anda tambahkan)
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 100, color: Colors.grey),
              ),
              
              const SizedBox(height: 16),
              
              // 10. TAMPILKAN DETAIL MENU
              // 'widget.menu' digunakan untuk mengakses data
              // dari kelas StatefulWidget di atas
              Text(
                widget.menu.name,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                'Rp ${widget.menu.price}',
                style: const TextStyle(fontSize: 22, color: Colors.red),
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                'Deskripsi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                widget.menu.description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}