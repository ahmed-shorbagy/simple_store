import 'package:dio/dio.dart';
import 'package:simple_store/core/constants/api_constants.dart';
import 'package:simple_store/core/utils/secure_storage_service.dart';
import 'package:simple_store/features/auth/models/user_model.dart';

class AuthRepository {
  final Dio _dio;
  final SecureStorageService _storage;

  AuthRepository(this._dio, {SecureStorageService? storage})
      : _storage = storage ?? SecureStorageService();

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      // Login to get token
      final loginResponse = await _dio.post(
        '${ApiConstants.baseUrl}/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (loginResponse.statusCode != 200) {
        throw Exception('Login failed');
      }

      final token = loginResponse.data['token'] as String;
      await _storage.saveToken(token);

      // Get user details
      final userResponse = await _dio.get(
        '${ApiConstants.baseUrl}/users/1', // TODO: Get actual user ID from token
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (userResponse.statusCode != 200) {
        throw Exception('Failed to get user details');
      }

      final user = UserModel.fromJson(
        userResponse.data as Map<String, dynamic>,
        token,
      );

      // Save user data securely
      await _storage.saveUser(user);

      return user;
    } catch (e) {
      throw Exception('Authentication failed: $e');
    }
  }

  Future<UserModel> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final signupResponse = await _dio.post(
        '${ApiConstants.baseUrl}/users',
        data: {
          'email': email,
          'username': username,
          'password': password,
        },
      );

      if (signupResponse.statusCode != 200) {
        throw Exception('Signup failed');
      }

      // After signup, perform login to get token and user details
      return await login(username: username, password: password);
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

  Future<UserModel?> getCurrentUser() async {
    return await _storage.getUser();
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }
}
