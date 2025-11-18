import 'package:flutter/foundation.dart';
import 'package:kanhas/models/canteen_data.dart';

class CanteenModel extends ChangeNotifier {
  final List<Canteen> _canteens = List.from(initialCanteens);

  List<Canteen> get canteens => _canteens;

  void addCanteen(Canteen canteen) {
    _canteens.add(canteen);
    notifyListeners();
  }

  void addMenuToCanteen(Canteen canteen, Menu menu) {
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);
    if (canteenIndex != -1) {
      _canteens[canteenIndex].menus.add(menu);
      notifyListeners();
    }
  }

  void deleteMenuFromCanteen(Canteen canteen, Menu menu) {
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);
    if (canteenIndex != -1) {
      _canteens[canteenIndex].menus.removeWhere((m) => m.name == menu.name);
      notifyListeners();
    }
  }

  void updateMenuInCanteen(Canteen canteen, Menu oldMenu, Menu newMenu) {
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);
    if (canteenIndex == -1) return;
    final menuIndex = _canteens[canteenIndex].menus.indexWhere(
          (m) => m.name == oldMenu.name && m.price == oldMenu.price,
    );
    if (menuIndex == -1) return;
    _canteens[canteenIndex].menus[menuIndex] = newMenu;
    notifyListeners();
  }

  void updateCanteen(Canteen oldCanteen, Canteen newCanteen) {
    final index = _canteens.indexWhere(
            (c) => c.name == oldCanteen.name && c.location == oldCanteen.location);
    if (index != -1) {
      _canteens[index] = newCanteen;
      notifyListeners();
    }
  }

  void deleteCanteen(Canteen canteen) {
    _canteens.removeWhere(
            (c) => c.name == canteen.name && c.location == canteen.location);
    notifyListeners();
  }
}