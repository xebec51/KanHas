import 'package:flutter/foundation.dart'; // Impor 'ChangeNotifier'
import 'package:kanhas/models/canteen_data.dart';

// 1. Definisikan CartItem (SAMA SEPERTI SEBELUMNYA)
class CartItem {
  final Menu menu;
  int quantity;

  CartItem({required this.menu, this.quantity = 1});
}

// 2. BUAT MODEL SEBAGAI "ChangeNotifier"
// Ini adalah kelas "manajer" kita.
class CartModel extends ChangeNotifier {

  // 3. Pindahkan daftar 'cart' ke DALAM kelas ini
  // Kita beri '_' (underscore) agar menjadi 'private'
  // (hanya bisa diakses oleh kelas ini)
  final List<CartItem> _items = [];

  // 4. Buat "getter" publik agar halaman lain bisa 'membaca'
  // daftar item tanpa bisa mengubahnya langsung.
  List<CartItem> get items => _items;

  // 5. Buat "getter" untuk total harga
  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item.menu.price * item.quantity));
  }

  // 6. Buat "getter" untuk jumlah item
  int get itemCount {
    return _items.length;
  }

  // 7. BUAT FUNGSI UNTUK MENGUBAH STATE
  // Ini adalah fungsi untuk "Tambah ke Keranjang"
  void add(CartItem item) {
    // Cek apakah item sudah ada di keranjang
    // 'firstWhere' akan error jika tidak ketemu, jadi kita pakai 'try-catch'
    try {
      // Cari item yang menunya sama
      CartItem existingItem = _items.firstWhere((i) => i.menu.name == item.menu.name);
      // Jika ketemu, tambahkan kuantitasnya
      existingItem.quantity += item.quantity;
    } catch (e) {
      // Jika tidak ketemu (error), tambahkan sebagai item baru
      _items.add(item);
    }

    // 8. "TERIAK!" / BERI TAHU SEMUA WIDGET!
    // Ini adalah bagian terpenting. Ini memberi tahu
    // semua widget yang 'mendengarkan' bahwa ada perubahan
    // dan mereka harus membangun ulang (rebuild) UI mereka.
    notifyListeners();
  }

  // Fungsi untuk Menghapus Item
  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // Fungsi untuk Menambah Kuantitas (di halaman keranjang)
  void increment(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  // Fungsi untuk Mengurangi Kuantitas (di halaman keranjang)
  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      // Jika kuantitas jadi 1 lalu dikurangi, hapus item
      _items.remove(item);
    }
    notifyListeners();
  }
}