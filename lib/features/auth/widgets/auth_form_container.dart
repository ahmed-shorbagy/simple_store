import 'package:flutter/material.dart';
import 'package:simple_store/core/theme/app_theme.dart';

class AuthFormContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const AuthFormContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              title,
              style: AppTheme.headlineStyle.copyWith(
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTheme.subtitleStyle,
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTheme.borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
