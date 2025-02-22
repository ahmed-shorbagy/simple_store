class AppConstants {
  static const String baseUrl = 'https://api.example.com';

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String productsEndpoint = '/products';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Timeouts
  static const int connectionTimeout = 10;
  static const int receiveTimeout = 10;

  // Validation
  static const int minPasswordLength = 6;

  // Pagination
  static const int itemsPerPage = 10;
}
