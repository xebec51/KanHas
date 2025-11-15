import 'package:flutter/foundation.dart';
// 1. Impor data lama kita, kita akan 'menyalin' datanya ke model ini
import 'package:kanhas/models/canteen_data.dart';

class CanteenModel extends ChangeNotifier {

  // 2. Pindahkan 'canteenList' ke dalam model ini
  // Kita salin data awalnya dari 'canteenList' global
  // Kita gunakan List.from() agar bisa diubah (add/remove)
  final List<Canteen> _canteens = List.from(canteenList);

  // 3. Buat 'getter' publik agar halaman lain bisa membaca
  List<Canteen> get canteens => _canteens;

  // --- FUNGSI CRUD UNTUK ADMIN ---

  // C: Create
  void addCanteen(Canteen canteen) {
    _canteens.add(canteen);
    notifyListeners(); // Beri tahu UI bahwa ada kantin baru!
  }

// R: Read (sudah ada di 'getter')

// U: Update (Belum kita implementasi, tapi ini tempatnya)
// void updateCanteen(Canteen oldCanteen, Canteen newCanteen) { ... }

// D: Delete (Belum kita implementasi, tapi ini tempatnya)
// void deleteCanteen(Canteen canteen) { ... }
}