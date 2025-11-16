import 'package:flutter/material.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/screens/menu_page.dart';
import 'package:kanhas/models/canteen_model.dart';
import 'package:provider/provider.dart';
import 'package:kanhas/screens/add_canteen_page.dart';
import 'package:kanhas/screens/edit_canteen_page.dart';
import 'package:kanhas/widgets/local_or_network_image.dart';

// --- UBAH MENJADI StatefulWidget ---
class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- TAMBAHKAN STATE UNTUK SEARCH ---
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Tambahkan listener untuk memperbarui UI saat mengetik
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  // ---------------------------------

  @override
  Widget build(BuildContext context) {
    final canteenModel = context.watch<CanteenModel>();

    // --- TAMBAHKAN LOGIKA FILTER ---
    final List<Canteen> filteredCanteens;
    if (_searchQuery.isEmpty) {
      // Jika tidak ada query, tampilkan semua
      filteredCanteens = canteenModel.canteens;
    } else {
      // Jika ada query, filter berdasarkan nama kantin
      filteredCanteens = canteenModel.canteens.where((canteen) {
        return canteen.name.toLowerCase().contains(_searchQuery);
      }).toList();
    }
    // -----------------------------

    return Scaffold(
      appBar: AppBar(
        // --- Gunakan widget.user ---
        title: Text('Kanhas - (${widget.user.username})'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GANTI Text MENJADI TextField ---
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari kantin...',
                prefixIcon: const Icon(Icons.search),
                // Tambahkan tombol clear (X)
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
            ),
            // ----------------------------------
            const SizedBox(height: 20),
            Text(
              'Silakan pilih kantin:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              // --- TAMBAHKAN PENANGANAN HASIL KOSONG ---
              child: filteredCanteens.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.store_mall_directory_outlined, size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Kantin tidak ditemukan',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    Text(
                      'Coba kata kunci lain.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              // ---------------------------------------
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 210,
                ),
                // --- GUNAKAN LIST YANG SUDAH DIFILTER ---
                itemCount: filteredCanteens.length,
                itemBuilder: (context, index) {
                  final Canteen canteen = filteredCanteens[index];
                  // ------------------------------------

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
                                // --- Gunakan widget.user ---
                                user: widget.user,
                              ),
                            ),
                          );
                        },
                      ),
                      // --- Gunakan widget.user ---
                      if (widget.user.role == UserRole.admin)
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
                      // --- Gunakan widget.user ---
                      if (widget.user.role == UserRole.admin)
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
      // --- Gunakan widget.user ---
      floatingActionButton: (widget.user.role == UserRole.admin)
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCanteenPage()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add_business, color: Colors.white),
      )
          : null,
    );
  }
}

// Widget CanteenCard (Tidak berubah)
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
            LocalOrNetworkImage(
              imageUrl: canteen.imageUrl,
              height: 120,
              width: double.infinity,
              errorIcon: Icons.store,
            ),
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