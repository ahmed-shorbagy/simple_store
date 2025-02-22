import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_store/core/router/app_router.dart';
import 'package:simple_store/core/theme/app_theme.dart';
import 'package:simple_store/core/widgets/custom_button.dart';
import 'package:simple_store/core/widgets/custom_text_field.dart';
import 'package:simple_store/features/auth/manager/auth_cubit.dart';
import 'package:simple_store/features/auth/manager/auth_state.dart';
import 'package:simple_store/features/auth/widgets/auth_form_container.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.goNamed(AppRoutes.kHomeName);
          }
        },
        builder: (context, state) {
          return AuthFormContainer(
            title: 'Welcome Back! 👋',
            subtitle: 'Please sign in to your account',
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _usernameController,
                      label: 'Username',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Sign In',
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().login(
                                username: _usernameController.text,
                                password: _passwordController.text,
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Don\'t have an account? Sign up',
                      isTextButton: true,
                      onPressed: () {
                        context.pushNamed(AppRoutes.kRegisterName);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
