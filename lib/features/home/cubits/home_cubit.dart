import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/product_model.dart';
import '../repositories/home_repository.dart';

// Home States
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ProductModel> products;
  HomeLoaded(this.products);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

// Home Cubit
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeInitial());

  Future<void> loadProducts() async {
    emit(HomeLoading());
    try {
      final products = await _homeRepository.getProducts();
      emit(HomeLoaded(products));
    } catch (e) {
      final error = e.toString();
      Fluttertoast.showToast(msg: error);
      emit(HomeError(error));
    }
  }

  Future<void> refreshProducts() async {
    try {
      final products = await _homeRepository.getProducts();
      emit(HomeLoaded(products));
    } catch (e) {
      final error = e.toString();
      Fluttertoast.showToast(msg: error);
    }
  }
}
