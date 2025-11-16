import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/screens/menu_page.dart';
import 'package:kanhas/models/canteen_model.dart';
import 'package:provider/provider.dart';
import 'package:kanhas/screens/add_canteen_page.dart';
import 'package:kanhas/screens/edit_canteen_page.dart';
import 'package:kanhas/widgets/local_or_network_image.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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
                // --- PERBAIKAN UI DI SINI ---
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 210, // 1. PAKSA TINGGI KARTU JADI 210px
                ),
                // ---------------------------
                itemCount: canteenModel.canteens.length,
                itemBuilder: (context, index) {
                  final Canteen canteen = canteenModel.canteens[index];

                  // Stack untuk tombol Admin (Logika Anda sudah benar)
                  return Stack(
                    children: [
                      CanteenCard(
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
                      ),
                      // Tombol Hapus
                      if (user.role == UserRole.admin)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.delete_forever_rounded, size: 20),
                            color: Colors.white,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.withAlpha(204),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Hapus Kantin'),
                                    content: Text(
                                      'Apakah Anda yakin ingin menghapus ${canteen.name}? '
                                          'Semua menu di dalamnya juga akan terhapus.',
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Batal'),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor: Colors.red),
                                        child: const Text('Hapus'),
                                        onPressed: () {
                                          context
                                              .read<CanteenModel>()
                                              .deleteCanteen(canteen);
                                          Navigator.of(dialogContext).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${canteen.name} telah dihapus.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      // Tombol Edit
                      if (user.role == UserRole.admin)
                        Positioned(
                          top: 40,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            color: Colors.white,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.blue.withAlpha(204),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCanteenPage(
                                    canteenToEdit: canteen,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Tombol FAB Admin
      floatingActionButton: (user.role == UserRole.admin)
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCanteenPage()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add_business, color: Colors.white),
      )
          : null,
    );
  }
}

// Widget CanteenCard
// Widget CanteenCard
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
            // --- GANTI Image.network MENJADI INI ---
            LocalOrNetworkImage(
              imageUrl: canteen.imageUrl,
              height: 120,
              width: double.infinity,
              errorIcon: Icons.store, // Ikon error spesifik
            ),
            // ------------------------------------

            Expanded(
              child: Padding(
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
            ),
          ],
        ),
      ),
    );
  }
}