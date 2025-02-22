import '../../../core/services/api_service.dart';
import '../../../core/services/service_locator.dart';
import '../models/product_model.dart';

class HomeRepository {
  final ApiService _apiService = locator<ApiService>();

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get('/products');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProductModel> getProductDetails(String productId) async {
    try {
      final response = await _apiService.get('/products/$productId');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    return 'Failed to fetch products: ${error.toString()}';
  }
}
