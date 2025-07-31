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
}
