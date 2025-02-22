import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_store/features/auth/models/user_model.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class SecureStorageService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            FlutterSecureStorage(
              aOptions: _getAndroidOptions(),
              iOptions: const IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: userJson);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    final tokenStr = await _storage.read(key: _tokenKey);
    if (userJson == null || tokenStr == null) return null;

    try {
      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userData, tokenStr);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteUser() async {
    await _storage.delete(key: _userKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
