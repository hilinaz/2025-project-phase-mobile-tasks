import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<void> insertProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
  Future<ProductEntity?> getProduct(String id);
  Future<List<ProductEntity>> getAllProducts();
} 