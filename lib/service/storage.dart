import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Save user data
  static Future<void> saveUser(User user) async {
    await _storage.write(key: _userKey, value: json.encode(user.toJson()));
  }

  // Get user data
  static Future<User?> getUser() async {
    final userData = await _storage.read(key: _userKey);
    if (userData != null) {
      return User.fromJson(json.decode(userData));
    }
    return null;
  }

  // Clear all auth data
  static Future<void> clearAuthData() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);

    // Double check - sometimes delete doesn't work properly
    await _storage.write(key: _tokenKey, value: '');
    await _storage.write(key: _userKey, value: '');
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    final user = await getUser();
    return token != null && token.isNotEmpty && user != null;
  }

  // Clear all data (nuclear option)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
