import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_store/features/auth/manager/auth_state.dart';
import 'package:simple_store/features/auth/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(AuthInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(
        username: username,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
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
      final user = await _authRepository.signup(
        email: email,
        username: username,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void logout() {
    emit(AuthUnauthenticated());
  }
}
