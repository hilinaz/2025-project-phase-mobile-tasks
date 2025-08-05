import '../../../../core/error/exception.dart';
import '../../../../core/services/http_service.dart';
import '../../../../core/utils/model_converter.dart';
import '../../doamin/entities/product.dart';
import '../models/product_model.dart';
import 'product_remote_datasource.dart';

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final HttpService httpService;

  ProductRemoteDatasourceImpl({required this.httpService});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final jsonList = await httpService.getList('');
    return ModelConverter.jsonListToProductModels(jsonList);
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final json = await httpService.get(id);
    return ModelConverter.jsonToProductModel(json);
  }

  @override
  Future<void> createProduct(Product product) async {
    final productModel = ModelConverter.productToModel(product);
    await httpService.post('', productModel.toJson());
  }

  @override
  Future<void> deleteProduct(String id) async {
    await httpService.delete(id);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final productModel = ModelConverter.productToModel(product);
    await httpService.put(product.id, productModel.toJson());
  }
}
