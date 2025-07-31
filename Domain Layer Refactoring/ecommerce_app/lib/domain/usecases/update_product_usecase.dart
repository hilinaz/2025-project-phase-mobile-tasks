import '../entities/product.dart';
import 'usecase.dart';

class UpdateProductUsecase implements UseCase<Product, Product> {
  final List<Product> _products;

  UpdateProductUsecase(this._products);

  @override
  Future<Product> call(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      return product;
    }
    throw Exception('Product not found');
  }
}
