import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

// Auth States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      final error = e.toString();
      Fluttertoast.showToast(msg: error);
      emit(AuthError(error));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.register(name, email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      final error = e.toString();
      Fluttertoast.showToast(msg: error);
      emit(AuthError(error));
    }
  }

  void logout() {
    emit(AuthInitial());
  }
}
