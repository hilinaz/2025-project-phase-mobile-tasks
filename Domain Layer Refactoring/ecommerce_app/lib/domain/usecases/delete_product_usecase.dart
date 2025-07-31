import '../entities/product.dart';
import 'usecase.dart';

class DeleteProductUsecase implements UseCase<bool, String> {
  final List<Product> _products;

  DeleteProductUsecase(this._products);

  @override
  Future<bool> call(String productId) async {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index != -1) {
      _products.removeAt(index);
      return true;
    }
    return false;
  }
}
