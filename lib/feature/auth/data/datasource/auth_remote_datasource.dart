import 'package:dio/dio.dart';
import 'package:mas_pos_app/core/services/dio_client.dart';
import 'package:mas_pos_app/feature/auth/data/model/login_request_model.dart';
import 'package:mas_pos_app/feature/auth/data/model/login_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login({required LoginRequestModel request});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasourceImpl(this._dioClient);

  @override
  Future<LoginResponseModel> login({required LoginRequestModel request}) async {
    try {
      final response = await _dioClient.dio.post(
        '/login',
        data: request.toJson(),
      );

      final loginResponse = LoginResponseModel.fromJson(response.data);

      // Save token if login is successful
      if (loginResponse.data?.token != null) {
        _dioClient.setToken(loginResponse.data!.token!);
      }

      return loginResponse;
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.response?.data['message']}');
      }
      throw Exception('Error during login: $e');
    }
  }
}
