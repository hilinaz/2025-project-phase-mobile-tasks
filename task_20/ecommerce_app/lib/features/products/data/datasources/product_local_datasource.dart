import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exception.dart';

import '../models/product_model.dart';

abstract class ProductLocalDatasource {
  Future<ProductModel> getProduct();
  Future<List<ProductModel>> getProducts();
  Future<void> cacheProduct(ProductModel productModel);
  Future<void> cacheProducts(List<ProductModel> productmodels);
}

class ProductLocalDatasourceImp implements ProductLocalDatasource {
  final SharedPreferences sharedPreferences;
  ProductLocalDatasourceImp(this.sharedPreferences);
  @override
  Future<void> cacheProduct(ProductModel productModel) {
    return sharedPreferences.setString(
        cacheKeySingle, jsonEncode(productModel.toJson()));
  }

  @override
 Future<void> cacheProducts(List<ProductModel> productModels) {
    final jsonList =
        productModels.map((product) => jsonEncode(product.toJson())).toList();

    return sharedPreferences.setStringList(cacheKeyList, jsonList);
  }

  final cacheKeySingle = 'CACHED FILE';
  final cacheKeyList ='CACHED FILE LIST';

  @override
  Future<ProductModel> getProduct() {
    final jsonString = sharedPreferences.getString(cacheKeySingle);
    if (jsonString != null) {
      return Future.value(ProductModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<ProductModel>> getProducts() {
    final jsonList = sharedPreferences.getStringList(cacheKeyList);

    if (jsonList != null) {
      final productModels = jsonList
          .map((jsonString) => ProductModel.fromJson(jsonDecode(jsonString)))
          .toList();

      return Future.value(productModels);
    } else {
      throw CacheException();
    }
  }
}
