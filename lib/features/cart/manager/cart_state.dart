import 'package:equatable/equatable.dart';
import 'package:simple_store/features/cart/models/cart_model.dart';

enum CartStatus {
  initial,
  loading,
  loaded,
  error,
}

class CartState extends Equatable {
  final CartStatus status;
  final CartModel? cart;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
  });

  CartState copyWith({
    CartStatus? status,
    CartModel? cart,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage];
}
