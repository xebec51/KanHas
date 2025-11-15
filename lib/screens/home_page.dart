import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/user_model.dart'; // Impor user model
import 'package:kanhas/screens/menu_page.dart';
import 'package:kanhas/screens/cart_page.dart';

class HomePage extends StatelessWidget {
  // Ganti dari 'String role' menjadi 'User user'
  final User user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tampilkan username dari objek user
        title: Text('Kanhas - (${user.username})'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ucapkan selamat datang ke username
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
                itemCount: canteenList.length,
                itemBuilder: (context, index) {
                  final Canteen canteen = canteenList[index];

                  return CanteenCard(
                    canteen: canteen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Kirim 'canteen' DAN 'user' ke MenuPage
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
              fit: BoxFit.cover, // <-- Agar gambar memenuhi 'card'
              // Efek 'loading' saat gambar diunduh
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child; // Gambar selesai
                return Container( // Tampilkan placeholder abu-abu
                  height: 120,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator(color: Colors.red)),
                );
              },
              // Efek jika gambar gagal di-load
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
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