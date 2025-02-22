import 'package:simple_store/core/utils/api_service.dart';
import 'package:simple_store/features/auth/models/auth_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<AuthModel> login(
      {required String username, required String password}) async {
    try {
      final response = await _apiService.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      return AuthModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthModel> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('/users', data: {
        'email': email,
        'username': username,
        'password': password,
      });

      return AuthModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
