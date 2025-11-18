// lib/screens/cart_page.dart

import 'package:flutter/material.dart';
import 'package:kanhas/models/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:kanhas/screens/order_history_page.dart';
import 'package:kanhas/widgets/local_or_network_image.dart';
// --- TAMBAHKAN IMPOR INI ---
import 'package:kanhas/models/order_history_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan 'Consumer' BUKAN 'context.watch'
    // agar kita bisa mengakses 'cart' di dalam builder
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        double totalPrice = cart.totalPrice;

        // Tampilan keranjang kosong
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

        // Tampilan keranjang jika ada isinya
        return Scaffold(
          appBar: AppBar(
            title: const Text('Keranjang Saya'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              // 1. DAFTAR ITEM
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 200),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final cartItem = cart.items[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
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
                                context.read<CartModel>().decrement(cartItem);
                              },
                            ),
                            Text(
                              '${cartItem.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                context.read<CartModel>().increment(cartItem);
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
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Column(
                    children: [
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

                      // --- PERBARUI LOGIKA 'onPressed' INI ---
                      ElevatedButton(
                        onPressed: () {
                          // 1. Ambil data keranjang saat ini
                          final items = cart.items;
                          final total = cart.totalPrice;

                          // 2. Tambahkan ke Riwayat Pesanan
                          context
                              .read<OrderHistoryModel>()
                              .addOrder(items, total);

                          // 3. Kosongkan Keranjang
                          context.read<CartModel>().clear();

                          // 4. Tampilkan notifikasi
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Checkout berhasil! Pesanan Anda telah dicatat.'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );

                          // 5. Navigasi ke Halaman Riwayat
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderHistoryPage(),
                            ),
                          );
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