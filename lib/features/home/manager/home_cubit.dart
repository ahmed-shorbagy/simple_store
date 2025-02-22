import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_store/core/utils/logger.dart';
import 'package:simple_store/features/home/manager/home_state.dart';
import 'package:simple_store/features/home/repositories/home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit({HomeRepository? homeRepository})
      : _homeRepository = homeRepository ?? HomeRepository(),
        super(HomeInitial());

  Future<void> loadProducts() async {
    emit(HomeLoading());
    try {
      Logger.info('Fetching products and categories');
      final products = await _homeRepository.getAllProducts();
      final categories = await _homeRepository.getCategories();

      Logger.info(
          'Fetched ${products.length} products and ${categories.length} categories');

      emit(HomeLoaded(
        products: products,
        categories: categories,
      ));
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to load products',
        error: e,
        stackTrace: stackTrace,
        tag: 'HomeCubit',
      );
      emit(HomeError(e.toString()));
    }
  }

  Future<void> filterByCategory(String category) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      try {
        Logger.info('Filtering products by category: $category');
        final products = await _homeRepository.getProductsByCategory(category);
        Logger.info(
            'Fetched ${products.length} products for category: $category');

        emit(currentState.copyWith(
          products: products,
          selectedCategory: category,
        ));
      } catch (e, stackTrace) {
        Logger.error(
          'Failed to filter products',
          error: e,
          stackTrace: stackTrace,
          tag: 'HomeCubit',
        );
        emit(HomeError(e.toString()));
      }
    }
  }

  void clearFilter() {
    final currentState = state;
    if (currentState is HomeLoaded) {
      loadProducts();
    }
  }
}
