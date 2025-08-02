import 'entities/product_entity.dart';
import 'repositories/product_repository_impl.dart';
import 'usecases/delete_product_usecase.dart';
import 'usecases/get_all_products_usecase.dart';
import 'usecases/get_product_usecase.dart';
import 'usecases/insert_product_usecase.dart';
import 'usecases/update_product_usecase.dart';

class ProductService {
  late ProductRepositoryImpl repository;
  late InsertProductUseCase insertUseCase;
  late UpdateProductUseCase updateUseCase;
  late DeleteProductUseCase deleteUseCase;
  late GetProductUseCase getProductUseCase;
  late GetAllProductsUseCase getAllProductsUseCase;

  ProductService() {
    repository = ProductRepositoryImpl();
    insertUseCase = InsertProductUseCase(repository);
    updateUseCase = UpdateProductUseCase(repository);
    deleteUseCase = DeleteProductUseCase(repository);
    getProductUseCase = GetProductUseCase(repository);
    getAllProductsUseCase = GetAllProductsUseCase(repository);
  }

  Future<void> addProduct(
      String name, String description, double price, String imageUrl) async {
    final product = ProductEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );
    await insertUseCase.execute(product);
  }

  Future<void> editProduct(ProductEntity product) async {
    await updateUseCase.execute(product);
  }

  Future<void> removeProduct(String id) async {
    await deleteUseCase.execute(id);
  }

  Future<ProductEntity?> findProduct(String id) async {
    return await getProductUseCase.execute(id);
  }

  Future<List<ProductEntity>> getAllProducts() async {
    return await getAllProductsUseCase.execute();
  }
}
