import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/screens/detail_page.dart';

// 1. UBAH MENJADI STATEFULWIDGET
class MenuPage extends StatefulWidget {
  final Canteen canteen;
  const MenuPage({super.key, required this.canteen});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Variabel state untuk melacak chip mana yang aktif
  String selectedCategory = 'All';
  // (Kita akan tambahkan logika search dan filter nanti)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ambil nama kantin dari 'widget.canteen'
        title: Text(widget.canteen.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () { /* Navigasi ke CartPage nanti */ },
          ),
        ],
      ),
      // 2. GUNAKAN SingleChildScrollView
      // Ini agar seluruh halaman bisa di-scroll,
      // menghindari overflow saat keyboard muncul atau item banyak
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3. SEARCH BAR (TextField)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari menu...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200], // Warna abu-abu muda
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Bulat penuh
                    borderSide: BorderSide.none, // Tanpa border
                  ),
                ),
                onChanged: (value) {
                  // Logika filter akan ditambahkan di sini
                },
              ),

              const SizedBox(height: 20),

              // 4. FILTER CHIPS (Horizontal List)
              _buildFilterChips(),

              const SizedBox(height: 20),

              // 5. JUDUL "ALL ITEMS"
              Text(
                'Semua Menu',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // 6. GRIDVIEW UNTUK MENU
              GridView.builder(
                // Pengaturan penting untuk GridView di dalam Column
                shrinkWrap: true, // Agar GridView pas dengan kontennya
                physics: const NeverScrollableScrollPhysics(), // Agar tidak bentrok scroll

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8, // Rasio kartu (sesuai 'CanteenCard')
                ),
                // Ambil daftar menu dari 'widget.canteen'
                itemCount: widget.canteen.menus.length,
                itemBuilder: (context, index) {
                  final Menu menu = widget.canteen.menus[index];

                  // 7. PANGGIL KARTU MENU YANG BARU
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
    );
  }

  // Widget helper pribadi untuk membuat filter chips
  Widget _buildFilterChips() {
    // Daftar kategori dummy (bisa Anda sesuaikan)
    final List<String> categories = ['All', 'Nasi', 'Minuman', 'Snack', 'Gorengan'];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Scroll ke samping
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          // Cek apakah chip ini yang sedang dipilih
          final bool isSelected = selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              // 'onSelected' adalah inti dari StatefulWidget di sini
              onSelected: (bool selected) {
                // Panggil setState untuk membangun ulang UI
                // dengan chip yang baru terpilih
                setState(() {
                  selectedCategory = category;
                  // Nanti kita akan panggil fungsi filter di sini
                });
              },
              backgroundColor: isSelected ? Colors.red[100] : Colors.grey[200],
              selectedColor: Colors.red[100], // Warna saat terpilih
              checkmarkColor: Colors.red, // Warna centang
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

// 8. BUAT WIDGET KARTU MENU (Terpisah)
// Ini mirip 'CanteenCard', tapi untuk 'Menu'
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
            // Gambar Placeholder
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.fastfood, size: 80, color: Colors.grey),
            ),
            Padding(
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
                      color: Colors.red[700], // Warna merah (sesuai tema)
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