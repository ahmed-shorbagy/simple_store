import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_store/core/router/app_router.dart';
import 'package:simple_store/core/theme/app_theme.dart';
import 'package:simple_store/core/utils/toast_service.dart';
import 'package:simple_store/features/cart/manager/cart_cubit.dart';
import 'package:simple_store/features/home/manager/home_cubit.dart';
import 'package:simple_store/features/home/manager/home_state.dart';
import 'package:simple_store/features/home/widgets/category_chip.dart';
import 'package:simple_store/features/home/widgets/product_card.dart';
import 'package:simple_store/features/home/widgets/product_card_shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Simple Store'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              GoRouter.of(context).push(AppRoutes.kCartView);
            },
            icon: const Badge(
              label: Text('0'),
              child: Icon(Icons.shopping_cart),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoadingGrid();
          }

          if (state is HomeError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ToastService.showCustomToast(
                message: state.message,
                type: ToastType.error,
              );
            });
            return const SizedBox.shrink();
          }

          if (state is HomeLoaded) {
            return Column(
              children: [
                // Categories
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      final isSelected = category == state.selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          category: category,
                          isSelected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              context
                                  .read<HomeCubit>()
                                  .filterByCategory(category);
                            } else {
                              context.read<HomeCubit>().clearFilter();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                // Products grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductCard(
                        product: product,
                        onAddToCart: () {
                          context.read<CartCubit>().addToCart(
                                productId: product.id,
                                userId: 1,
                                quantity: 1,
                              );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}
