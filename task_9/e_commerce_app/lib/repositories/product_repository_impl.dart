import '../entities/product_entity.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  List<ProductEntity> products = [];

  @override
  Future<void> insertProduct(ProductEntity product) async {
    products.add(product);
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    products.removeWhere((product) => product.id == id);
  }

  @override
  Future<ProductEntity?> getProduct(String id) async {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    return products;
  }
} 