// lib/screens/detail_page.dart

import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:provider/provider.dart';
import 'package:kanhas/models/cart_model.dart';
import 'package:kanhas/widgets/local_or_network_image.dart';

class DetailPage extends StatefulWidget {
  // ... (Constructor tidak berubah) ...
  final Menu menu;
  const DetailPage({super.key, required this.menu});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- INI PERUBAHANNYA ---
                // Bungkus gambar dengan Hero
                Hero(
                  // Tag harus SAMA PERSIS dengan di MenuPage
                  tag: widget.menu.name,
                  child: LocalOrNetworkImage(
                    imageUrl: widget.menu.imageUrl,
                    height: 300,
                    width: double.infinity,
                    errorIcon: Icons.fastfood,
                  ),
                ),
                // ------------------------------------

                // Area teks di bawah gambar
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Menu
                      Text(
                        widget.menu.name,
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

                      // Counter Kuantitas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Harga
                          Text(
                            'Rp ${widget.menu.price * quantity}',
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
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.red),
                                  onPressed: _decrementQuantity,
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.red),
                                  onPressed: _incrementQuantity,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // ... (Sisa kode placeholder tidak berubah) ...
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 10),
                      const Text('Add on', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('Nanti di sini ada pilihan Add on'),
                      const SizedBox(height: 20),
                      const Text('Special Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('Nanti di sini ada TextField untuk instruksi'),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ... (Kode Tombol Add to Cart tidak berubah) ...
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
                    color: Colors.black.withAlpha(26),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  final item = CartItem(
                    menu: widget.menu,
                    quantity: quantity,
                  );
                  Provider.of<CartModel>(context, listen: false).add(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.menu.name} (x${item.quantity}) ditambahkan ke keranjang.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
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

          // ... (Kode Tombol Back tidak berubah) ...
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