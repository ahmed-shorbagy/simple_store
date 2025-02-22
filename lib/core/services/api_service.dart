import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;

  ApiResponse.success(this.data)
      : error = null,
        success = true;
  ApiResponse.error(this.error)
      : data = null,
        success = false;
}

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Future<ApiResponse<T>> request<T>({
    required String path,
    required String method,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: headers,
        ),
      );

      return ApiResponse.success(response.data as T);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error('An unexpected error occurred: $e');
    }
  }

  Future<ApiResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return request<T>(
      path: path,
      method: 'GET',
      queryParameters: queryParameters,
    );
  }

  Future<ApiResponse<T>> post<T>(String path, {dynamic data}) async {
    return request<T>(
      path: path,
      method: 'POST',
      data: data,
    );
  }

  Future<ApiResponse<T>> put<T>(String path, {dynamic data}) async {
    return request<T>(
      path: path,
      method: 'PUT',
      data: data,
    );
  }

  Future<ApiResponse<T>> delete<T>(String path) async {
    return request<T>(
      path: path,
      method: 'DELETE',
    );
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet connection.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        switch (statusCode) {
          case 400:
            return data?['message'] ?? 'Bad request';
          case 401:
            return 'Unauthorized. Please login again.';
          case 403:
            return 'You don\'t have permission to access this resource.';
          case 404:
            return 'The requested resource was not found.';
          case 500:
            return 'Internal server error. Please try again later.';
          default:
            return 'Server error occurred (${statusCode ?? "unknown"})';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled';

      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';

      default:
        return 'Network error occurred';
    }
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
