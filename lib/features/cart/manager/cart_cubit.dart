import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_store/features/cart/manager/cart_state.dart';
import 'package:simple_store/features/cart/repositories/cart_repository.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;

  CartCubit(this._cartRepository) : super(const CartState());

  Future<void> fetchCart(int userId) async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      final cart = await _cartRepository.getUserCart(userId);
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: cart,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> addToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      await _cartRepository.addToCart(
        userId: userId,
        productId: productId,
        quantity: quantity,
      );
      await fetchCart(userId);
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateCartItem({
    required int cartId,
    required int productId,
    required int quantity,
    required int userId,
  }) async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      await _cartRepository.updateCartItem(
        cartId: cartId,
        productId: productId,
        quantity: quantity,
      );
      await fetchCart(userId);
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> deleteCartItem({
    required int cartId,
    required int userId,
  }) async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      await _cartRepository.deleteCartItem(cartId);
      await fetchCart(userId);
    } catch (e) {
      emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
