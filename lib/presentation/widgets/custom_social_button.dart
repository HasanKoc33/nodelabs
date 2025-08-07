import 'package:flutter/material.dart';
import 'package:nodelabs/core/theme/app_theme.dart';

/// CustomSocialButton ekranı
@immutable
final class CustomSocialButton extends StatelessWidget {
  /// CustomSocialButton yapıcı methot
  const CustomSocialButton({
    required this.icon,
    required this.onTap,
    super.key,
  });

  /// CustomSocialButton ikon
  final IconData icon;

  /// CustomSocialButton onTap
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF404040),
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: AppTheme.textPrimary,
            size: 24,
          ),
        ),
      ),
    );
  }
}