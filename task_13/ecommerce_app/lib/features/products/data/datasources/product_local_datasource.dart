import '../models/product_model.dart';

abstract class ProductLocalDatasource {
  Future<ProductModel> getProduct();
  Future<void> cacheProduct(ProductModel productModel);

  Future<void> deleteProduct(String id) async {}

  Future getProductById(String id) async {}

  Future getAllProducts() async {}
}
