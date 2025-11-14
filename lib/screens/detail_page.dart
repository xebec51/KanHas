import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/cart_model.dart'; // <-- TAMBAHKAN INI

// Tetap StatefulWidget, tapi state-nya akan lebih kompleks
class DetailPage extends StatefulWidget {
  final Menu menu;
  const DetailPage({super.key, required this.menu});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // 1. BUAT STATE UNTUK KUANTITAS
  // Ini adalah data yang akan berubah, menggantikan 'isFavorite'
  int quantity = 1;

  // 2. FUNGSI UNTUK MENAMBAH KUANTITAS
  void _incrementQuantity() {
    // Panggil setState untuk memperbarui UI
    setState(() {
      quantity++;
    });
  }

  // 3. FUNGSI UNTUK MENGURANGI KUANTITAS
  void _decrementQuantity() {
    setState(() {
      // Tambahkan logika agar kuantitas tidak bisa kurang dari 1
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kita gunakan Stack untuk menumpuk tombol 'Add to cart'
    // di atas konten utama
    return Scaffold(
      body: Stack(
        children: [
          // 4. KONTEN UTAMA YANG BISA DI-SCROLL
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // [GAMBAR PLACEHOLDER]
                // Sesuai referensi, gambar ada di atas
                Container(
                  height: 300, // Gambar lebih besar
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.fastfood, size: 150, color: Colors.grey),
                ),

                // Area teks di bawah gambar
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Menu
                      Text(
                        widget.menu.name, // Ambil dari widget
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Deskripsi Menu
                      Text(
                        widget.menu.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      const SizedBox(height: 20),

                      // 5. COUNTER KUANTITAS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Harga
                          Text(
                            'Rp ${widget.menu.price * quantity}', // Harga dikali kuantitas
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Tombol + dan -
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                // Tombol Kurang (-)
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.red),
                                  onPressed: _decrementQuantity,
                                ),
                                // Teks Kuantitas
                                Text(
                                  '$quantity', // Tampilkan state kuantitas
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Tombol Tambah (+)
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.red),
                                  onPressed: _incrementQuantity,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Placeholder untuk Add on & Special Instructions
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      const Text('Add on', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('Nanti di sini ada pilihan Add on'),
                      const SizedBox(height: 20),
                      const Text('Special Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('Nanti di sini ada TextField untuk instruksi'),

                      // Beri jarak aman di bawah agar tidak tertutup tombol
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 6. TOMBOL "ADD TO CART" (Mengambang di bawah)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // --- LOGIKA ADD TO CART ---
                  // 1. Buat CartItem baru
                  final item = CartItem(
                    menu: widget.menu,
                    quantity: quantity, // Ambil state kuantitas
                  );

                  // 2. Tambahkan ke daftar keranjang global
                  cart.add(item);

                  // 3. Tampilkan notifikasi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.menu.name} (x${item.quantity}) ditambahkan ke keranjang.'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // 4. Kembali ke halaman sebelumnya
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Warna tombol
                  foregroundColor: Colors.white, // Warna teks
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add to cart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // 7. TOMBOL BACK (Mengambang di atas)
          Positioned(
            top: 40,
            left: 10,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}