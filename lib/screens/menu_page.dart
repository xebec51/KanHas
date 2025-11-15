import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/user_model.dart'; // Impor user model
import 'package:kanhas/screens/detail_page.dart';
import 'package:kanhas/screens/cart_page.dart';

// Ubah jadi StatefulWidget
class MenuPage extends StatefulWidget {
  final Canteen canteen;
  final User user; // Terima objek User
  const MenuPage({super.key, required this.canteen, required this.user});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.canteen.name),
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

              // GridView untuk Menu
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: widget.canteen.menus.length,
                itemBuilder: (context, index) {
                  final Menu menu = widget.canteen.menus[index];

                  return MenuCard(
                    menu: menu,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(menu: menu),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // --- FITUR ADMIN ---
      // Tampilkan tombol FAB HANYA jika role-nya admin
      floatingActionButton: (widget.user.role == UserRole.admin)
          ? FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur Tambah Menu untuk Admin!'),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null, // Jika bukan admin, tidak ada tombol
    );
  }

  // Widget helper untuk filter chips
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
}

// Widget untuk Kartu Menu (Tetap sama)
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
                  child: const Center(child: CircularProgressIndicator(color: Colors.red)),
                );
              },
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