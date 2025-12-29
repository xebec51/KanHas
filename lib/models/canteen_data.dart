// lib/models/canteen_data.dart
import 'dart:convert';

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

  // --- SERIALIZATION LOGIC ---
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
      'menus': menus.map((x) => x.toMap()).toList(),
    };
  }

  factory Canteen.fromMap(Map<String, dynamic> map) {
    return Canteen(
      name: map['name'],
      location: map['location'],
      imageUrl: map['imageUrl'],
      menus: List<Menu>.from(
        (map['menus'] as List<dynamic>).map<Menu>(
              (x) => Menu.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Canteen.fromJson(String source) =>
      Canteen.fromMap(json.decode(source));
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

  // --- SERIALIZATION LOGIC ---
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      name: map['name'],
      price: map['price'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Menu.fromJson(String source) => Menu.fromMap(json.decode(source));
}

// Data Awal (Fallback jika penyimpanan kosong)
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
        'https://images.pexels.com/photos/6937455/pexels-photo-6937455.jpeg',
        price: 15000,
        description:
        'Nasi kuning lezat dengan ayam suwir, telur dadar, dan sambal.',
      ),
      Menu(
        name: 'Soto Ayam',
        imageUrl:
        'https://images.pexels.com/photos/12676932/pexels-photo-12676932.jpeg',
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
        description:
        'Sayuran segar dengan saus kacang gurih, lontong, dan kerupuk.',
      ),
      Menu(
        name: 'Es Teh Manis',
        imageUrl:
        'https://images.unsplash.com/photo-1594136579292-d98588fe6429?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        price: 5000,
        description: 'Es teh manis segar untuk melepas dahaga.',
      ),
    ],
  ),
];