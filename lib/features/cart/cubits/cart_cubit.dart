import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../home/models/product_model.dart';

// Cart Item Model
class CartItem {
  final ProductModel product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get total => product.price * quantity;
}

// Cart States
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  CartLoaded(this.items);

  double get total => items.fold(0, (sum, item) => sum + item.total);
}

// Cart Cubit
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartLoaded([]));

  void addToCart(ProductModel product) {
    final currentState = state as CartLoaded;
    final items = List<CartItem>.from(currentState.items);

    final existingItemIndex =
        items.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      items[existingItemIndex] = CartItem(
        product: product,
        quantity: items[existingItemIndex].quantity + 1,
      );
    } else {
      items.add(CartItem(product: product, quantity: 1));
    }

    emit(CartLoaded(items));
    Fluttertoast.showToast(msg: '${product.name} added to cart');
  }

  void removeFromCart(String productId) {
    final currentState = state as CartLoaded;
    final items = List<CartItem>.from(currentState.items);

    items.removeWhere((item) => item.product.id == productId);

    emit(CartLoaded(items));
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity < 1) return;

    final currentState = state as CartLoaded;
    final items = List<CartItem>.from(currentState.items);

    final index = items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final product = items[index].product;
      items[index] = CartItem(product: product, quantity: quantity);
      emit(CartLoaded(items));
    }
  }

  void clearCart() {
    emit(CartLoaded([]));
  }
}
