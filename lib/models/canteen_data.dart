class Canteen {
  final String name;
  final String location;
  final String imageUrl;
  final List<Menu> menus;

  Canteen({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.menus,
  });
}

class Menu {
  final String name;
  final int price;
  final String description;
  final String imageUrl;

  Menu({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });
}

final List<Canteen> initialCanteens = [
  Canteen(
    name: 'Kantin Rama',
    location: 'Gedung FT, Lantai 1',
    imageUrl:
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop',
    menus: [
      Menu(
        name: 'Nasi Kuning',
        imageUrl:
            'https://images.unsplash.com/photo-1627907228175-2bf8c68f99b8?q=80&w=1770&auto=format&fit=crop',
        price: 15000,
        description: 'Nasi kuning lezat dengan ayam suwir, telur dadar, dan sambal.',
      ),
      Menu(
        name: 'Soto Ayam',
        imageUrl:
            'https://images.unsplash.com/photo-1589078103838-517861b518c8?q=80&w=1856&auto=format&fit=crop',
        price: 12000,
        description: 'Soto ayam hangat dengan bihun, tauge, dan kuah kaldu.',
      ),
    ],
  ),
  Canteen(
    name: 'Kantin Sinta',
    location: 'Area Fakultas FIB',
    imageUrl:
        'https://images.unsplash.com/photo-1555992336-fb0d29498b13?q=80&w=1887&auto=format&fit=crop',
    menus: [
      Menu(
        name: 'Gado-Gado',
        imageUrl:
            'https://images.unsplash.com/photo-1604909052743-94e838986d24?q=80&w=2070&auto=format&fit=crop',
        price: 10000,
        description: 'Sayuran segar dengan saus kacang gurih, lontong, dan kerupuk.',
      ),
      Menu(
        name: 'Es Teh Manis',
        imageUrl:
            'https://images.unsplash.com/photo-1542442491-3e79e60226b5?q=80&w=1887&auto=format&fit=crop',
        price: 5000,
        description: 'Es teh manis segar untuk melepas dahaga.',
      ),
    ],
  ),
];