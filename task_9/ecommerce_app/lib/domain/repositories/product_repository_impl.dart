import '../entities/product.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [];

  @override
  Future<List<Product>> getAllProducts() async {
    return _products;
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    _products.add(product);
    return product;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      return product;
    }
    throw Exception('Product not found');
  }

  @override
  Future<bool> deleteProduct(String id) async {
    final index = _products.indexWhere((product) => product.id == id);
    if (index != -1) {
      _products.removeAt(index);
      return true;
    }
    return false;
  }
}
