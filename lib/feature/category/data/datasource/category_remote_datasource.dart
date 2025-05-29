import 'package:dio/dio.dart';
import 'package:mas_pos_app/core/services/dio_client.dart';
import 'package:mas_pos_app/feature/category/data/models/category_request_model.dart';
import 'package:mas_pos_app/feature/category/data/models/category_response_model.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoryResponseModel> getCategories();
  Future<AddCategoryResponseModel> addCategory(AddCategoryRequestModel request);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final DioClient _dioClient;

  CategoryRemoteDataSourceImpl(this._dioClient);

  @override
  Future<CategoryResponseModel> getCategories() async {
    try {
      final response = await _dioClient.dio.get('/category');
      return CategoryResponseModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.response?.data['message']}');
      }
      throw Exception('Error fetching categories: $e');
    }
  }

  @override
  Future<AddCategoryResponseModel> addCategory(
      AddCategoryRequestModel request) async {
    try {
      final response = await _dioClient.dio.post(
        '/category',
        data: request.toJson(),
      );
      return AddCategoryResponseModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.response?.data['message']}');
      }
      throw Exception('Error adding category: $e');
    }
  }
}
