import 'package:flutter/material.dart';
import 'package:kanhas/models/cart_model.dart'; // Impor model keranjang kita
import 'package:provider/provider.dart'; // 1. Impor Provider

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    // 2. KITA AKAN "MENDENGARKAN" PERUBAHAN
    // Kita bungkus Scaffold kita dengan 'Consumer<CartModel>'
    // 'Consumer' akan otomatis 'rebuild' setiap kali 'notifyListeners()' dipanggil
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        // 'cart' di sini adalah 'CartModel' kita

        // 3. Ambil total harga dari 'cart' model
        double totalPrice = cart.totalPrice;

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
                // 4. Ambil jumlah item dari 'cart' model
                itemCount: cart.itemCount,
                itemBuilder: (context, index) {
                  // 5. Ambil item dari 'cart' model
                  final cartItem = cart.items[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child:
                          const Icon(Icons.fastfood, color: Colors.grey),
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

                        // 6. GUNAKAN FUNGSI DARI 'CartModel'
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                // Panggil fungsi 'decrement' dari model
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
                                // Panggil fungsi 'increment' dari model
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
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Method',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Card/Cash',
                              style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Price',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rp $totalPrice', // 7. Tampilkan total harga dari model
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          print('Checkout dengan total Rp $totalPrice');
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
                          'Checkout',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
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