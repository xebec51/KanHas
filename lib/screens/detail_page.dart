import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:provider/provider.dart';
import 'package:kanhas/models/cart_model.dart';
import 'package:kanhas/widgets/local_or_network_image.dart';

class DetailPage extends StatefulWidget {
  final Menu menu;
  const DetailPage({super.key, required this.menu});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  // State baru untuk tombol 'like'
  bool isFavorite = false;

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
      // Kita tidak perlu AppBar, karena kita buat sendiri
      body: Stack(
        children: [
          // KONTEN UTAMA YANG BISA DI-SCROLL
          CustomScrollView(
            slivers: [
              // --- BAGIAN 1: GAMBAR HEADER (SLIVER) ---
              SliverAppBar(
                expandedHeight: 300.0, // Tinggi gambar saat diperluas
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true, // Appbar akan tetap terlihat saat scroll ke atas
                stretch: true, // Gambar akan 'stretch' jika ditarik
                automaticallyImplyLeading: false, // Sembunyikan tombol back default
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: Hero(
                    tag: widget.menu.name, // Tag Hero dari MenuPage
                    child: LocalOrNetworkImage(
                      imageUrl: widget.menu.imageUrl,
                      width: double.infinity,
                      height: 350, // Beri tinggi lebih
                      fit: BoxFit.cover,
                      errorIcon: Icons.fastfood,
                    ),
                  ),
                ),
              ),

              // --- BAGIAN 2: KONTEN DETAIL ---
              SliverToBoxAdapter(
                child: Padding(
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
                          height: 1.5, // Beri jarak antar baris
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 20),

                      // Counter Kuantitas (Desain baru)
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
                              color: Colors.red[100], // Ubah warna
                              borderRadius: BorderRadius.circular(30),
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
                                    color: Colors.red, // Ubah warna
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

                      // Beri jarak aman di bawah agar tidak tertutup tombol
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- BAGIAN 3: TOMBOL ADD TO CART (FLOATING) ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
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
                      content: Text(
                          '${item.menu.name} (x${item.quantity}) ditambahkan ke keranjang.'),
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Tambahkan ke Keranjang',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // --- BAGIAN 4: TOMBOL KEMBALI & SUKA (FLOATING) ---
          Positioned(
            top: 40, // Sesuaikan dengan status bar
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Back
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // Tombol Like/Favorite
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isFavorite
                              ? '${widget.menu.name} ditambahkan ke favorit'
                              : '${widget.menu.name} dihapus dari favorit'),
                          backgroundColor: Colors.red[400],
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}