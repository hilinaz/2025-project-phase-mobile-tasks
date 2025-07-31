import '../entities/product.dart';
import 'usecase.dart';

class ViewProductUsecase implements UseCase<Product?, String> {
  final List<Product> _products;

  ViewProductUsecase(this._products);

  @override
  Future<Product?> call(String productId) async {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }
}
