import '../entities/product.dart';
import 'usecase.dart';

class CreateProductUsecase implements UseCase<Product, Product> {
  final List<Product> _products;

  CreateProductUsecase(this._products);

  @override
  Future<Product> call(Product product) async {
    _products.add(product);
    return product;
  }
}
