import 'package:flutter/material.dart';
// 1. IMPORT DATA MODEL (KITA BUTUH 'CLASS CANTEEN')
import 'package:kanhas/models/canteen_data.dart';
// 2. IMPORT HALAMAN DETAIL (TUJUAN SELANJUTNYA)
import 'package:kanhas/screens/detail_page.dart';

class MenuPage extends StatelessWidget {
  
  // 3. DEKLARASIKAN VARIABEL UNTUK MENANGKAP DATA KANTIN
  final Canteen canteen;

  // 4. BUAT CONSTRUCTOR UNTUK MENERIMA DATA KANTIN
  // Inilah yang kita panggil dari HomePage: MenuPage(canteen: canteen)
  const MenuPage({super.key, required this.canteen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // 5. TAMPILKAN NAMA KANTIN DI APPBAR
      appBar: AppBar(
        title: Text('Menu ${canteen.name}'), // Contoh: "Menu Kantin Teknik"
        centerTitle: true,
      ),
      
      // 6. GUNAKAN LISTVIEW.BUILDER UNTUK MENAMPILKAN MENU
      body: ListView.builder(
        // Ambil jumlah item dari DAFTAR MENU di dalam objek kantin
        itemCount: canteen.menus.length,
        
        itemBuilder: (context, index) {
          // Ambil 1 menu dari daftar menu kantin berdasarkan 'index'
          final Menu menu = canteen.menus[index];

          // Kembalikan ListTile yang sudah diisi data menu
          return ListTile(
            leading: const Icon(Icons.restaurant_menu), // Ikon menu
            
            // 7. GUNAKAN DATA ASLI DARI MODEL MENU
            title: Text(menu.name),
            subtitle: Text('Rp ${menu.price}'), // Tampilkan harga
            trailing: const Icon(Icons.chevron_right),
            
            // 8. TAMBAHKAN NAVIGASI KE DETAIL PAGE
            onTap: () {
              // Aksi navigasi ke DetailPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    // Kirim seluruh objek 'menu'
                    // ke halaman detail
                    menu: menu,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}