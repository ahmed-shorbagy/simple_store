import 'package:dio/dio.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/service_locator.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService = locator<ApiService>();

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = UserModel.fromJson(response.data);
      _apiService.setAuthToken(user.token ?? '');
      return user;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      return UserModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      if (response != null) {
        return response.data['message'] ?? 'An error occurred';
      }
      return 'Network error occurred';
    }
    return 'An unexpected error occurred';
  }
}
