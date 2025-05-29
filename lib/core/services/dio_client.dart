import 'package:dio/dio.dart';
import 'package:mas_pos_app/api/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';
  late final Dio _dio;

  DioClient(this._prefs) {
    _dio = _createDioInstance();
  }

  Dio get dio => _dio;

  void setToken(String token) {
    _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  void clearToken() {
    _prefs.remove(_tokenKey);
  }

  Dio _createDioInstance() {
    final dio = Dio(BaseOptions(
      baseUrl: Urls.base,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add token interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    // Add logging interceptor
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    return dio;
  }
}
