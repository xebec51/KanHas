import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/canteen_model.dart'; // Impor CanteenModel
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/screens/detail_page.dart';
import 'package:kanhas/screens/cart_page.dart';
import 'package:kanhas/screens/add_menu_page.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  final Canteen canteen;
  final User user;
  const MenuPage({super.key, required this.canteen, required this.user});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    // 1. "Tonton" CanteenModel agar UI 'rebuild' saat data berubah
    final canteenModel = context.watch<CanteenModel>();

    // 2. Ambil data kantin yang 'segar' dari model
    final Canteen currentCanteen = canteenModel.canteens.firstWhere(
          (c) => c.name == widget.canteen.name,
      orElse: () => widget.canteen,
    );

    return Scaffold(
      appBar: AppBar(
        // 3. Gunakan data 'segar'
        title: Text(currentCanteen.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar (Tidak berubah)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari menu...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),

              // Filter Chips (Tidak berubah)
              _buildFilterChips(),
              const SizedBox(height: 20),

              Text(
                'Semua Menu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // GridView untuk Menu
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                // --- PERBAIKAN UTAMA (UI) ---
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  crossAxisSpacing: 16, // Jarak horizontal
                  mainAxisSpacing: 16, // Jarak vertikal
                  mainAxisExtent: 210, // 4. PAKSA TINGGI KARTU JADI 210px
                ),
                // -----------------------------

                // 5. Gunakan data 'segar'
                itemCount: currentCanteen.menus.length,
                itemBuilder: (context, index) {
                  // 6. Gunakan data 'segar'
                  final Menu menu = currentCanteen.menus[index];

                  return Stack(
                    children: [
                      MenuCard(
                        menu: menu,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(menu: menu),
                            ),
                          );
                        },
                      ),
                      // Tombol Hapus Admin (Tidak berubah)
                      if (widget.user.role == UserRole.admin)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.delete_forever_rounded),
                            color: Colors.white,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.8),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              // 7. Kirim data 'segar' ke dialog
                              _showDeleteConfirmationDialog(
                                  context, currentCanteen, menu);
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // Tombol FAB Admin (Tidak berubah)
      floatingActionButton: (widget.user.role == UserRole.admin)
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMenuPage(
                // 8. Kirim data 'segar' ke halaman tambah
                canteen: currentCanteen,
              ),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }

  // Widget helper filter chips (Tidak berubah)
  Widget _buildFilterChips() {
    final List<String> categories = ['All', 'Nasi', 'Minuman', 'Snack', 'Gorengan'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              backgroundColor: isSelected ? Colors.red[100] : Colors.grey[200],
              selectedColor: Colors.red[100],
              checkmarkColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
            ),
          );
        },
      ),
    );
  }

  // Dialog Konfirmasi Hapus (Tidak berubah)
  void _showDeleteConfirmationDialog(
      BuildContext context, Canteen canteen, Menu menu) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Menu'),
          content: Text('Apakah Anda yakin ingin menghapus ${menu.name}?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
              onPressed: () {
                // 10. Gunakan 'canteen' yang dikirim (data 'segar')
                context
                    .read<CanteenModel>()
                    .deleteMenuFromCanteen(canteen, menu);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${menu.name} telah dihapus.'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// Widget Kartu Menu
class MenuCard extends StatelessWidget {
  final Menu menu;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.menu,
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
            // Gambar
            Image.network(
              menu.imageUrl,
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
                  child: const Icon(Icons.broken_image,
                      size: 80, color: Colors.grey),
                );
              },
            ),

            // Area Teks
            // 'Expanded' akan memaksa area ini mengisi
            // sisa ruang yang ditinggalkan oleh gambar (210 - 120 = 90px)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Menu
                    Text(
                      menu.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Harga Menu
                    Text(
                      'Rp ${menu.price}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1, // Tambahkan ini juga untuk harga
                      overflow: TextOverflow.ellipsis, //
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