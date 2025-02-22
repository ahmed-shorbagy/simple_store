import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_store/core/utils/toast_service.dart';
import 'package:simple_store/features/cart/manager/cart_cubit.dart';
import 'package:simple_store/features/cart/manager/cart_state.dart';
import 'package:simple_store/features/cart/widgets/cart_item_card.dart';

class CartDisplay extends StatelessWidget {
  const CartDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.status == CartStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == CartStatus.error) {
          // Show toast instead of error in UI
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ToastService.showCustomToast(
              message: state.errorMessage ?? 'Unknown error',
              type: ToastType.error,
            );
          });
          return const Center(child: Text('Your cart is empty.'));
        } else if (state.cart?.products.isEmpty ?? true) {
          return const Center(child: Text('Your cart is empty.'));
        }

        return ListView.builder(
          itemCount: state.cart?.products.length ?? 0,
          itemBuilder: (context, index) {
            final item = state.cart!.products[index];
            return CartItemCard(
              item: item,
              onDelete: () {
                context.read<CartCubit>().deleteCartItem(
                      cartId: state.cart!.id,
                      userId: state.cart!.userId,
                    );
              },
              onQuantityChanged: (newQuantity) {
                context.read<CartCubit>().updateCartItem(
                      cartId: state.cart!.id,
                      productId: item.product.id,
                      quantity: newQuantity,
                      userId: state.cart!.userId,
                    );
              },
            );
          },
        );
      },
    );
  }
}
