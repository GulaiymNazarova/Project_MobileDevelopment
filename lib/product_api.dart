import 'package:firstflutterproject/product.dart';
import 'package:firstflutterproject/rest_api.dart';
import 'package:dio/dio.dart';

abstract class ProductApi extends RestApi {
  Future<List<Product>> getProducts();
  // Оставили объявление в абстрактном классе
  Future<Product> getProductById(Object? id); 
}

class ProductApiImpl extends RestApi {
  Dio dio;
  ProductApiImpl() : dio = Dio();

  @override
  Future<List<Product>> getProducts() async {
    var response = await dio.get("$baseUrl/products");
    List<Product> products = [];
    if (response.statusCode == 200) {
      var data = response.data;
      for (var element in data["products"]) {
        products.add(Product.fromJson(element));
      }
    }
    return products;
  }

  @override
  Future<Product> getProductById(Object? id) async {
    var response = await dio.get("$baseUrl/products/$id");
    if (response.statusCode == 200) {
      return Product.fromJson(response.data);
    } else {
      throw Exception("Не удалось загрузить продукт с id: $id");
    }
  }
}