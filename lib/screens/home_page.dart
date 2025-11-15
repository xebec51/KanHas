import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/screens/menu_page.dart';
import 'package:kanhas/screens/cart_page.dart';
// 1. Impor CanteenModel dan Provider
import 'package:kanhas/models/canteen_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // 2. Tonton (watch) CanteenModel di sini
    // Kita panggil di dalam 'build' agar UI-nya 'rebuild'
    // setiap kali ada kantin baru ditambahkan.
    // Kita gunakan context.watch<NamaModel>()
    final canteenModel = context.watch<CanteenModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Kanhas - (${user.username})'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang, ${user.username}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Silakan pilih kantin:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                // 3. Ambil 'itemCount' dari 'canteenModel'
                itemCount: canteenModel.canteens.length,
                itemBuilder: (context, index) {
                  // 4. Ambil 1 kantin dari 'canteenModel'
                  final Canteen canteen = canteenModel.canteens[index];

                  return CanteenCard(
                    canteen: canteen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuPage(
                            canteen: canteen,
                            user: user,
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

      // 5. FITUR ADMIN "TAMBAH KANTIN"
      // Kita gunakan 'FloatingActionButton' yang sama
      // seperti di 'MenuPage'
      floatingActionButton: (user.role == UserRole.admin)
          ? FloatingActionButton(
        onPressed: () {
          // (Nanti kita akan navigasi ke halaman 'Add Canteen')
          // Untuk sekarang, kita coba tambahkan 'dummy'

          // Buat kantin dummy baru
          final newCanteen = Canteen(
            name: 'Kantin Baru #${canteenModel.canteens.length + 1}',
            location: 'Lokasi Baru',
            imageUrl: 'https://images.unsplash.com/photo-1579435661625-3c586116c483?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA3fDB8MXxzZWFyY2h8MTR8fGNhZmZlfGVufDB8fHx8MTY1ODMzNjQyMg&ixlib=rb-1.2.1&q=80&w=400',
            menus: [],
          );

          // Panggil fungsi 'addCanteen' dari CanteenModel
          // Kita gunakan 'read' (listen: false) karena kita di dalam 'onPressed'
          // Cara baca: context.read<NamaModel>().namaFungsi()
          context.read<CanteenModel>().addCanteen(newCanteen);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newCanteen.name} ditambahkan!')),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add_business, color: Colors.white),
      )
          : null, // Jika bukan mahasiswa, tidak ada tombol
    );
  }
}

// CanteenCard (Tetap sama, tidak perlu diubah)
class CanteenCard extends StatelessWidget {
  final Canteen canteen;
  final VoidCallback onTap;

  const CanteenCard({
    super.key,
    required this.canteen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              canteen.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Center(
                      child: CircularProgressIndicator(color: Colors.red)),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey[300],
                  child:
                  const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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