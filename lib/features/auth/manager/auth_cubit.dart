import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_store/core/theme/app_theme.dart';
import 'package:simple_store/core/utils/logger.dart';
import 'package:simple_store/features/auth/manager/auth_state.dart';
import 'package:simple_store/features/auth/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({Dio? dio})
      : _authRepository = AuthRepository(dio ?? Dio()),
        super(AuthInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      Logger.info('Attempting login for user: $username');
      final user = await _authRepository.login(
        username: username,
        password: password,
      );
      Logger.info('Login successful for user: ${user.username}');

      Fluttertoast.showToast(
        msg: "Login successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.secondaryColor,
        textColor: Colors.white,
      );

      emit(AuthAuthenticated(user));
    } catch (e, stackTrace) {
      Logger.error(
        'Login failed',
        error: e,
        stackTrace: stackTrace,
        tag: 'AuthCubit',
      );

      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        textColor: Colors.white,
      );

      emit(AuthError(e.toString()));
    }
  }

  Future<void> signup({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      Logger.info('Attempting signup for user: $username');
      final user = await _authRepository.signup(
        email: email,
        username: username,
        password: password,
      );
      Logger.info('Signup successful for user: ${user.username}');

      Fluttertoast.showToast(
        msg: "Registration successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.secondaryColor,
        textColor: Colors.white,
      );

      emit(AuthAuthenticated(user));
    } catch (e, stackTrace) {
      Logger.error(
        'Signup failed',
        error: e,
        stackTrace: stackTrace,
        tag: 'AuthCubit',
      );

      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.errorColor,
        textColor: Colors.white,
      );

      emit(AuthError(e.toString()));
    }
  }

  void logout() {
    Logger.info('User logged out');
    Fluttertoast.showToast(
      msg: "Logged out successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.primaryColor,
      textColor: Colors.white,
    );
    emit(AuthUnauthenticated());
  }
}
