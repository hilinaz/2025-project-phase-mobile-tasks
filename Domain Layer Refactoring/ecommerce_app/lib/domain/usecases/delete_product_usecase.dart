import '../repositories/product_repository.dart';
import 'usecase.dart';

class DeleteProductUsecase implements UseCase<bool, String> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<bool> call(String productId) async {
    return await repository.deleteProduct(productId);
  }
}
