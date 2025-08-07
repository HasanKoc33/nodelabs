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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('auth.termsAndConditions'.tr()),
            backgroundColor: const Color(0xFFE53E3E),
          ),
        );
        return;
      }
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _goToLogin() {
    getIt<NavigationService>().goToLogin();
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
                    'auth.registerSubtitle'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Name Field
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'auth.name'.tr(),
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF888888),
                      size: 20,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'auth.nameRequired'.tr();
                      }
                      if (value.length < 2) {
                        return 'validation.minLength'.tr(namedArgs: {'count': '2'});
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

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

                  // Confirm Password Field
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'auth.confirmPassword'.tr(),
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF888888),
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF888888),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'auth.confirmPasswordRequired'.tr();
                      }
                      if (value != _passwordController.text) {
                        return 'validation.passwordsNotMatch'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Terms and Conditions Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFFE53E3E),
                        checkColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF888888),
                          width: 1.5,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'auth.termsAndConditions'.tr(),
                                ),
                                TextSpan(
                                  text: ' ${'auth.termsOfUse'.tr()}',
                                  style: const TextStyle(
                                    color: Color(0xFFE53E3E),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _register,
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
                                    'auth.registerButton'.tr(),
                                    style: const TextStyle(
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
                      const SizedBox(width: 16),
                      CustomSocialButton(
                        icon: Icons.apple,
                        onTap: () {
                          // Apple login implementation
                        },
                      ),
                      const SizedBox(width: 16),
                      CustomSocialButton(
                        icon: Icons.facebook,
                        onTap: () {
                          // Facebook login implementation
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'auth.alreadyHaveAccount'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: _goToLogin,
                        child: Text(
                          'auth.login'.tr(),
                          style: const TextStyle(
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
