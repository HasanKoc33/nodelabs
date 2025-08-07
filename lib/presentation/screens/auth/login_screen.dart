import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/di/injection.dart';
import 'package:nodelabs/core/services/navigation_service.dart';
import 'package:nodelabs/core/theme/app_theme.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_event.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_state.dart';
import 'package:nodelabs/presentation/widgets/custom_social_button.dart';
import 'package:nodelabs/presentation/widgets/custom_text_field.dart';

/// LoginScreen ekranı
class LoginScreen extends StatefulWidget {
  /// LoginScreen ekranı
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _goToRegister() {
    getIt<NavigationService>().goToRegister();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            getIt<NavigationService>().goToHome();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
              const Spacer(),

              // Title
              Text(
                'auth.welcome'.tr(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'auth.welcomeSubtitle'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Email Field
              CustomTextField(
                controller: _emailController,
                hintText: 'auth.email'.tr(),
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Color(0xFF888888),
                  size: 20,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'auth.emailRequired'.tr();
                  }
                  if (!RegExp(
                    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'auth.invalidEmail'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              CustomTextField(
                controller: _passwordController,
                hintText: 'auth.password'.tr(),
                obscureText: _obscurePassword,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF888888),
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF888888),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'auth.passwordRequired'.tr();
                  }
                  if (value.length < 6) {
                    return 'auth.passwordMinLength'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Forgot Password
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    // Forgot password implementation
                  },
                  child: Text(
                    'auth.forgotPassword'.tr(),
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF888888),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Login Button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53E3E),
                        // Red color from image
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: const Color(0xFF404040),
                        elevation: 0,
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
                                'auth.login'.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomSocialButton(
                    icon: Icons.g_mobiledata,
                    onTap: () {
                      // Google login implementation
                    },
                  ),
                   SizedBox(width: 16),
                  CustomSocialButton(
                    icon: Icons.apple, // Apple
                    onTap: () {
                      // Apple login implementation
                    },
                  ),
                  const SizedBox(width: 16),
                  CustomSocialButton(
                    icon: Icons.facebook, // Apple
                    onTap: () {
                      // Facebook login implementation
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'auth.dontHaveAccount'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToRegister,
                    child: Text(
                      'auth.register'.tr(),
                      style: TextStyle(
                        color: Color(0xFFE53E3E),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFE53E3E),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
