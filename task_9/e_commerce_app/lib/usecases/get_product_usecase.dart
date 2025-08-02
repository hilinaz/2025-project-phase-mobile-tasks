import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductUseCase {
  final ProductRepository repository;

  GetProductUseCase(this.repository);

  Future<ProductEntity?> execute(String id) async {
    return await repository.getProduct(id);
  }
}
