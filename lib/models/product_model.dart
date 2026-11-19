/// DTO. Живёт только в Data Layer, в Presentation не попадает.
class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'];
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: (json['description'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      rating: rating is Map ? ((rating['rate'] ?? 0) as num).toDouble() : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating': {'rate': rating},
      };
}
