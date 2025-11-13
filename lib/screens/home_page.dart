import 'package.flutter/material.dart';
// 1. IMPORT DATA MODEL KITA
import 'package:kanhas/models/canteen_data.dart';
// 2. IMPORT HALAMAN TUJUAN (MENU PAGE)
import 'package:kanhas/screens/menu_page.dart';

class HomePage extends StatelessWidget {
  final String role;
  const HomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kanhas - ($role)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang, $role!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Silakan pilih kantin:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            // 3. UBAH DARI LISTVIEW MENJADI LISTVIEW.BUILDER
            Expanded(
              // ListView.builder adalah cara efisien untuk membuat daftar
              // yang bisa di-scroll, terutama jika datanya banyak.
              child: ListView.builder(
                // Ambil jumlah item dari daftar kantin kita
                itemCount: canteenList.length,
                
                // 'builder' akan membuat widget untuk setiap item
                itemBuilder: (context, index) {
                  // Ambil 1 kantin dari daftar berdasarkan 'index'-nya
                  final Canteen canteen = canteenList[index];

                  // Kembalikan ListTile yang sudah diisi data asli
                  return ListTile(
                    leading: const Icon(Icons.store),
                    
                    // 4. GUNAKAN DATA ASLI DARI MODEL
                    title: Text(canteen.name),
                    subtitle: Text(canteen.location),
                    trailing: const Icon(Icons.chevron_right),
                    
                    // 5. TAMBAHKAN NAVIGASI DI onTap
                    onTap: () {
                      // Aksi navigasi ke MenuPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuPage(
                            // Kirim seluruh objek 'canteen'
                            // ke halaman menu
                            canteen: canteen,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}