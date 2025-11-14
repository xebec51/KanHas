import 'package:kanhas/models/canteen_data.dart';

// 1. Definisikan "CartItem"
// Ini adalah "cetakan" untuk item yang ada di keranjang.
// Isinya adalah Menu + kuantitas yang dipilih.
class CartItem {
  final Menu menu;
  int quantity;

  CartItem({required this.menu, this.quantity = 1});
}

// 2. Buat "Global Cart"
// Ini adalah daftar sederhana yang akan menyimpan semua CartItem kita.
// Ini bisa diakses dari mana saja di dalam aplikasi.
// (Untuk aplikasi besar, kita akan pakai State Management seperti Provider,
// tapi untuk submission ini, cara ini adalah yang paling sederhana).
List<CartItem> cart = [];