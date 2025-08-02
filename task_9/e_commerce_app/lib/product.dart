import 'entities/product_entity.dart';

class Product {
  String name;
  String description;
  String category;
  double price;
  double rating;
  String imagePath;

  Product({
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.rating = 4.0,
    this.imagePath = 'images/product.jpg',
  });

  ProductEntity toEntity() {
    return ProductEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      price: price,
      imageUrl: imagePath,
    );
  }

  static Product fromEntity(ProductEntity entity) {
    return Product(
      name: entity.name,
      description: entity.description,
      category: 'General',
      price: entity.price,
      imagePath: entity.imageUrl,
    );
  }
}
