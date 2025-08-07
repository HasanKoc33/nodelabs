import 'package:flutter/material.dart';

/// CustomTextField ekranı
@immutable
final class CustomTextField extends StatelessWidget {
  /// CustomTextField yapıcı methot
  const CustomTextField({
    required this.controller, required this.hintText, super.key,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
  });

  /// CustomTextField controller
  final TextEditingController controller;

  /// CustomTextField hintText
  final String hintText;

  /// CustomTextField özellikleri
  final bool obscureText;

  /// CustomTextField klavye türü
  final TextInputType keyboardType;

  /// CustomTextField sagdaki ikon
  final Widget? suffixIcon;

  /// CustomTextField soldaki ikon
  final Widget? prefixIcon;

  /// CustomTextField validator
  final String? Function(String?)? validator;

  /// CustomTextField onChanged
  final void Function(String)? onChanged;

  /// CustomTextField maxLines
  final int maxLines;

  /// CustomTextField enabled
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      enabled: enabled,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF888888),
          fontSize: 16,
        ),
        suffixIcon: suffixIcon,
        prefixIcon:
            prefixIcon != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: prefixIcon,
                )
                : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.only(
          left: prefixIcon != null ? 0 : 16,
          right: suffixIcon != null ? 0 : 16,
          top: 16,
          bottom: 16,
        ),
      ),
    );
  }
}
