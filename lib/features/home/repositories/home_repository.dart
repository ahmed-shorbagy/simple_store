import 'package:simple_store/core/utils/api_service.dart';
import 'package:simple_store/features/home/models/product_model.dart';

class HomeRepository {
  final ApiService _apiService;

  HomeRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _apiService.get('/products');
      return (response as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _apiService.get('/products/category/$category');
      return (response as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _apiService.get('/products/categories');
      return (response as List).map((category) => category.toString()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
