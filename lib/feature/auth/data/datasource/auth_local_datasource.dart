import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDatasource {
  Future<void> saveCredentials(String email, String password);
  Future<Map<String, String?>> getCredentials();
  Future<void> clearCredentials();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences _prefs;
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';

  AuthLocalDatasourceImpl(this._prefs);

  @override
  Future<void> saveCredentials(String email, String password) async {
    await _prefs.setString(_emailKey, email);
    await _prefs.setString(_passwordKey, password);
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    return {
      'email': _prefs.getString(_emailKey),
      'password': _prefs.getString(_passwordKey),
    };
  }

  @override
  Future<void> clearCredentials() async {
    await _prefs.remove(_emailKey);
    await _prefs.remove(_passwordKey);
  }
}
