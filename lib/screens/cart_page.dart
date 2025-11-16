import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart'; // <-- Hapus ini (Warning dari task sebelumnya)
import 'package:kanhas/models/cart_model.dart';
import 'package:provider/provider.dart';
// --- TAMBAHKAN IMPOR INI ---
import 'package:kanhas/screens/order_history_page.dart';

import '../widgets/local_or_network_image.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        double totalPrice = cart.totalPrice;

        // --- TAMBAHKAN UI UNTUK KERANJANG KOSONG ---
        if (cart.items.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Keranjang Saya'),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang Anda Kosong',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ayo, mulai pesan makanan!',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        }
        // -------------------------------------------

        // Jika keranjang tidak kosong, tampilkan seperti biasa
        return Scaffold(
          appBar: AppBar(
            title: const Text('Keranjang Saya'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              // 1. DAFTAR ITEM (Bisa di-scroll)
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 200),
                itemCount: cart.items.length, // <-- Ganti ke cart.items.length
                itemBuilder: (context, index) {
                  final cartItem = cart.items[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        // --- GANTI TAMPILAN GAMBAR ---
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: LocalOrNetworkImage(
                            imageUrl: cartItem.menu.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorIcon: Icons.fastfood,
                          ),
                        ),
                        // -----------------------------
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.menu.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                'Rp ${cartItem.menu.price}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                cart.decrement(cartItem);
                              },
                            ),
                            Text(
                              '${cartItem.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                cart.increment(cartItem);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),

              // 2. RINGKASAN & PEMBAYARAN
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
                  child: Column(
                    children: [
                      // ... (Payment method tidak berubah) ...
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Price',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rp $totalPrice',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- UBAH LOGIKA 'onPressed' INI ---
                      ElevatedButton(
                        onPressed: () {
                          // 1. Panggil fungsi clear()
                          context.read<CartModel>().clear();

                          // 2. Tampilkan notifikasi sukses
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout berhasil! Pesanan Anda sedang diproses.'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // 3. Navigasi ke Halaman Riwayat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderHistoryPage(),
                            ),
                          );
                        },
                        // ... (style tidak berubah) ...
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // ---------------------------------
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}