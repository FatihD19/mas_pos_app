import 'package:dio/dio.dart';
import 'package:mas_pos_app/core/services/dio_client.dart';
import 'package:mas_pos_app/feature/product/data/model/product_request_model.dart';
import 'package:mas_pos_app/feature/product/data/model/product_response_model.dart';

abstract class ProductRemoteDatasource {
  Future<ProductResponseModel> getProducts();
  Future<AddProductResponseModel> postProduct(AddProductRequestModel request);
  Future<bool> deleteProduct(String productid);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final DioClient _dioClient;

  ProductRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ProductResponseModel> getProducts() async {
    try {
      final response = await _dioClient.dio.get('/product');
      return ProductResponseModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.response?.data['message']}');
      }
      throw Exception('Error fetching products: $e');
    }
  }

  @override
  Future<AddProductResponseModel> postProduct(
      AddProductRequestModel request) async {
    try {
      final formData = FormData.fromMap({
        'category_id': request.categoryId,
        'name': request.name,
        'price': request.price,
        if (request.picturePath != null)
          'picture': await MultipartFile.fromFile(request.picturePath!,
              filename: request.picturePath!.split('/').last),
      });

      final response = await _dioClient.dio.post('/product', data: formData);
      return AddProductResponseModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.response?.data['message']}');
      }
      throw Exception('Error adding product: $e');
    }
  }

  @override
  Future<bool> deleteProduct(String productid) {
    try {
      final response = _dioClient.dio.delete('/product/$productid');
      return response.then((res) => res.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.response?.data['message']}');
      }
      throw Exception('Error deleting product: $e');
    }
  }
}
