import 'package:flutter/material.dart';
import 'package:kanhas/models/cart_model.dart'; // Impor model keranjang kita

// 1. BUAT SEBAGAI STATEFULWIDGET
// Kita membutuhkannya agar bisa mengubah kuantitas
// atau menghapus item langsung dari keranjang
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // (Nanti kita bisa tambahkan fungsi-fungsi
  // seperti _incrementItem, _decrementItem, _removeItem di sini)

  @override
  Widget build(BuildContext context) {
    // Hitung total harga
    // 'fold' adalah cara cepat untuk menjumlahkan nilai dalam list
    double totalPrice = cart.fold(0, (sum, item) => sum + (item.menu.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Saya'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. DAFTAR ITEM (Bisa di-scroll)
          ListView.builder(
            // Beri padding di bagian bawah agar tidak tertutup tombol
            padding: const EdgeInsets.only(bottom: 200),
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final cartItem = cart[index];

              // Ini adalah widget untuk satu item di keranjang
              // (Mirip UI referensi)
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    // Gambar Placeholder
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),

                    // Nama & Harga
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.menu.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'Rp ${cartItem.menu.price}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),

                    // Counter Kuantitas (Mirip DetailPage)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () {
                            setState(() {
                              if (cartItem.quantity > 1) {
                                cartItem.quantity--;
                              } else {
                                // Jika kuantitas jadi 0, hapus item
                                cart.removeAt(index);
                              }
                            });
                          },
                        ),
                        Text(
                          '${cartItem.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            setState(() {
                              cartItem.quantity++;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),

          // 2. RINGKASAN & PEMBAYARAN (Mengambang di bawah)
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
                  // Placeholder Metode Pembayaran (Sesuai Referensi)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Card/Cash', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const Divider(height: 30),

                  // Total Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp $totalPrice', // Tampilkan total harga
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tombol Checkout
                  ElevatedButton(
                    onPressed: () {
                      // Aksi checkout
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}