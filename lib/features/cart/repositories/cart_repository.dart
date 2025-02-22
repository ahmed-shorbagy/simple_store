import 'package:dio/dio.dart';
import 'package:simple_store/core/constants/api_constants.dart';
import 'package:simple_store/features/cart/models/cart_model.dart';
import 'package:simple_store/features/home/models/product_model.dart';

class CartRepository {
  final Dio _dio;

  CartRepository(this._dio);

  Future<CartModel> getUserCart(int userId) async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/carts/$userId');

      if (response.statusCode == 200) {
        final cartData = response.data as Map<String, dynamic>;

        // Fetch product details for each item in cart
        final products = cartData['products'] as List<dynamic>;
        final enrichedProducts = await Future.wait(
          products.map((product) async {
            final productId = product['productId'] as int;
            final quantity = product['quantity'] as int;

            final productResponse = await _dio.get(
              '${ApiConstants.baseUrl}/products/$productId',
            );

            if (productResponse.statusCode == 200) {
              final productData = productResponse.data as Map<String, dynamic>;
              return {
                ...product,
                'product': productData,
              };
            }
            throw Exception('Failed to fetch product details');
          }),
        );

        return CartModel.fromJson({
          ...cartData,
          'products': enrichedProducts,
        });
      }
      throw Exception('Failed to fetch cart');
    } catch (e) {
      throw Exception('Failed to fetch cart: $e');
    }
  }

  Future<void> addToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    try {
      await _dio.post(
        '${ApiConstants.baseUrl}/carts',
        data: {
          'userId': userId,
          'date': DateTime.now().toIso8601String(),
          'products': [
            {
              'productId': productId,
              'quantity': quantity,
            }
          ]
        },
      );
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> updateCartItem({
    required int cartId,
    required int productId,
    required int quantity,
  }) async {
    try {
      await _dio.put(
        '${ApiConstants.baseUrl}/carts/$cartId',
        data: {
          'products': [
            {
              'productId': productId,
              'quantity': quantity,
            }
          ]
        },
      );
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  Future<void> deleteCartItem(int cartId) async {
    try {
      await _dio.delete('${ApiConstants.baseUrl}/carts/$cartId');
    } catch (e) {
      throw Exception('Failed to delete cart item: $e');
    }
  }
}
