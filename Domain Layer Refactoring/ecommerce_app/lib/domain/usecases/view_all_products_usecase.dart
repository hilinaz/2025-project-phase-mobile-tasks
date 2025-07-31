import '../entities/product.dart';
import 'usecase.dart';

class ViewAllProductsUsecase implements UseCase<List<Product>, NoParams> {
  final List<Product> _products;

  ViewAllProductsUsecase(this._products);

  @override
  Future<List<Product>> call(NoParams params) async {
    return _products;
  }
}
