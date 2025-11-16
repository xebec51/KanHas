import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/canteen_model.dart'; // Impor CanteenModel
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/screens/detail_page.dart';
import 'package:kanhas/screens/add_menu_page.dart';
import 'package:provider/provider.dart';
import 'package:kanhas/screens/edit_menu_page.dart'; // Impor Halaman Edit
import 'package:kanhas/widgets/local_or_network_image.dart';

class MenuPage extends StatefulWidget {
  final Canteen canteen;
  final User user;
  const MenuPage({super.key, required this.canteen, required this.user});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'All';

  // --- TAMBAHKAN INI ---
  final _searchController = TextEditingController();
  String _searchQuery = '';
  // --------------------

  // --- TAMBAHKAN initState ---
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }
  // -------------------------

  // --- TAMBAHKAN dispose ---
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  // -----------------------

  @override
  Widget build(BuildContext context) {
    final canteenModel = context.watch<CanteenModel>();
    final Canteen currentCanteen = canteenModel.canteens.firstWhere(
          (c) => c.name == widget.canteen.name,
      orElse: () => widget.canteen,
    );

    // --- LOGIKA FILTER SEKARANG DIPERBARUI ---
    // 1. Filter berdasarkan Kategori
    List<Menu> filteredMenus;
    if (selectedCategory == 'All') {
      filteredMenus = currentCanteen.menus;
    } else {
      filteredMenus = currentCanteen.menus.where((menu) {
        return menu.name.toLowerCase().contains(selectedCategory.toLowerCase());
      }).toList();
    }

    // 2. Filter (hasil dari no 1) berdasarkan Pencarian
    if (_searchQuery.isNotEmpty) {
      filteredMenus = filteredMenus.where((menu) {
        return menu.name.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    // --- AKHIR BLOK LOGIKA ---

    return Scaffold(
      appBar: AppBar(
        title: Text(currentCanteen.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                // --- MODIFIKASI INI ---
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari menu...',
                  prefixIcon: const Icon(Icons.search),
                  // Tambahkan tombol clear
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                // onChanged dihapus, karena kita pakai listener
                // -----------------------
              ),
              const SizedBox(height: 20),

              // Filter Chips
              _buildFilterChips(),
              const SizedBox(height: 20),

              Text(
                'Semua Menu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // --- TAMBAHKAN INI JIKA HASIL KOSONG ---
              if (filteredMenus.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Menu tidak ditemukan',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      Text(
                        'Coba kata kunci atau filter lain.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              else
              // -----------------------------------
              // GridView untuk Menu
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 210, // Tinggi Kartu Kaku
                  ),
                  itemCount: filteredMenus.length,
                  itemBuilder: (context, index) {
                    final Menu menu = filteredMenus[index];

                    // --- Stack tidak berubah ---
                    return Stack(
                      children: [
                        // Anak #1: Kartu Menu
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

                        // Anak #2: Tombol Hapus (Hanya Admin)
                        if (widget.user.role == UserRole.admin)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.delete_forever_rounded),
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
                                _showDeleteConfirmationDialog(
                                    context, currentCanteen, menu);
                              },
                            ),
                          ),

                        // Anak #3: Tombol Edit (Hanya Admin)
                        if (widget.user.role == UserRole.admin)
                          Positioned(
                            top: 40, // Posisikan di bawah tombol hapus
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              color: Colors.white,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.blue.withAlpha(204), // Warna beda
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // Navigasi ke Halaman Edit
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditMenuPage(
                                      canteen: currentCanteen,
                                      menuToEdit: menu,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    );
                    // --- AKHIR PERBAIKAN STACK ---
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
            // --- INI PERUBAHANNYA ---
            // Bungkus gambar dengan Hero
            Hero(
              // Tag harus unik untuk setiap item
              tag: menu.name,
              child: LocalOrNetworkImage(
                imageUrl: menu.imageUrl,
                height: 120,
                width: double.infinity,
                errorIcon: Icons.fastfood,
              ),
            ),
            // ------------------------------------

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      'Rp ${menu.price}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w600,
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