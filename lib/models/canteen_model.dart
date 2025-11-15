import 'package:flutter/foundation.dart';
import 'package:kanhas/models/canteen_data.dart';

class CanteenModel extends ChangeNotifier {
  final List<Canteen> _canteens = List.from(canteenList);

  List<Canteen> get canteens => _canteens;

  // --- FUNGSI CRUD UNTUK ADMIN ---

  // C: Create Canteen (HANYA ADA SATU)
  void addCanteen(Canteen canteen) {
    _canteens.add(canteen);
    notifyListeners();
  }

  // C: Create Menu
  void addMenuToCanteen(Canteen canteen, Menu menu) {
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);

    if (canteenIndex != -1) {
      _canteens[canteenIndex].menus.add(menu);
      notifyListeners();
    }
  }
}