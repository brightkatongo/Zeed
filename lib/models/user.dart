class Product {
  final int id;
  final String name;
  final Farmer farmer;
  final double price;
  final String unit;
  final String quantity;
  final String category;
  final String description;
  final String imageUrl;
  
  Product({
    required this.id,
    required this.name,
    required this.farmer,
    required this.price,
    required this.unit,
    required this.quantity,
    required this.category,
    required this.description,
    required this.imageUrl,
  });
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      farmer: Farmer.fromJson(json['farmer']),
      price: json['price'].toDouble(),
      unit: json['unit'],
      quantity: json['quantity'],
      category: json['category'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Farmer {
  final int id;
  final String name;
  final String location;
  final bool verified;
  final double rating;
  
  Farmer({
    required this.id,
    required this.name,
    required this.location,
    required this.verified,
    required this.rating,
  });
  
  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      verified: json['verified'],
      rating: json['rating'].toDouble(),
    );
  }
}
