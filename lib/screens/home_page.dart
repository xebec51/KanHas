import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/screens/menu_page.dart';
import 'package:kanhas/screens/cart_page.dart';
// 1. Kita akan buat Halaman Keranjang nanti
// import 'package:kanhas/screens/cart_page.dart';

class HomePage extends StatelessWidget {
  final String role;
  const HomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kanhas - ($role)'),
        centerTitle: true,
        // 2. TAMBAHKAN IKON KERANJANG DI APPBAR
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // Navigasi ke Halaman Keranjang
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
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
            Text(
              'Silakan pilih kantin:',
              style: Theme.of(context).textTheme.titleLarge, // Style lebih baik
            ),
            const SizedBox(height: 10),

            // 3. UBAH DARI LISTVIEW MENJADI GRIDVIEW
            Expanded(
              // GridView.builder untuk tata letak 2 kolom
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  crossAxisSpacing: 16, // Jarak horizontal antar kartu
                  mainAxisSpacing: 16, // Jarak vertikal antar kartu
                  childAspectRatio: 0.8, // Rasio kartu (lebar vs tinggi)
                ),
                itemCount: canteenList.length,
                itemBuilder: (context, index) {
                  final Canteen canteen = canteenList[index];

                  // 4. PANGGIL WIDGET KARTU KANTIN YANG BARU
                  return CanteenCard(
                    canteen: canteen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuPage(canteen: canteen),
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

// 5. BUAT WIDGET TERPISAH UNTUK KARTU KANTIN
// Ini adalah praktik 'clean code'
class CanteenCard extends StatelessWidget {
  final Canteen canteen;
  final VoidCallback onTap; // Fungsi yang akan dipanggil saat di-klik

  const CanteenCard({
    super.key,
    required this.canteen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Gunakan 'InkWell' agar kartu bisa di-klik
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias, // Memotong gambar agar pas
        elevation: 4, // Efek bayangan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Sudut melengkung
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [GAMBAR PLACEHOLDER]
            // Sesuai referensi, gambar ada di atas
            Container(
              height: 120, // Tinggi gambar
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.store, size: 80, color: Colors.grey),
            ),

            // Area teks di bawah gambar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Kantin
                  Text(
                    canteen.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Lokasi Kantin
                  Text(
                    canteen.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}