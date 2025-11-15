import 'package:flutter/material.dart';
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/screens/cart_page.dart';
import 'package:kanhas/screens/home_page.dart';
import 'package:kanhas/screens/profile_page.dart';

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 1. State untuk melacak tab mana yang aktif
  int _selectedIndex = 0;

  // 2. Daftar halaman (tab) yang akan ditampilkan
  // Kita 'late' (tunda) inisialisasi agar bisa mengakses 'widget.user'
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Inisialisasi daftar halaman di sini
    _pages = [
      // Tab 0: Home
      HomePage(user: widget.user),
      // Tab 1: Cart
      const CartPage(),
      // Tab 2: Profile
      ProfilePage(user: widget.user),
    ];
  }

  // 3. Fungsi untuk mengubah tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 4. Tampilkan halaman yang sesuai dengan state '_selectedIndex'
      // Kita gunakan IndexedStack agar state setiap halaman (posisi scroll, dll)
      // tetap terjaga saat berpindah tab.
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // 5. Definisikan BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        // Tampilan
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red, // Warna ikon yang aktif
        unselectedItemColor: Colors.grey, // Warna ikon yang tidak aktif

        // Fungsionalitas
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex, // Beri tahu Navbar tab mana yang aktif
        onTap: _onItemTapped, // Panggil fungsi ini saat tab di-klik
      ),
    );
  }
}