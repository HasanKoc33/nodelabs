import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

/// MainNavigationWrapper provides a custom bottom navigation bar
class MainNavigationWrapper extends StatelessWidget {

  /// Creates an instance of [MainNavigationWrapper].
  const MainNavigationWrapper({super.key, required this.child});
  /// The child widget to display in the body of the scaffold.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Extend body below bottom nav bar
      body: child,
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton(
                  icon: Icons.home_outlined,
                  label: 'navigation.home'.tr(),
                  isSelected: _calculateSelectedIndex(context) == 0,
                  onTap: () => _onItemTapped(0, context),
                ),
                _buildNavButton(
                  icon: Icons.person_outline,
                  label: 'navigation.profile'.tr(),
                  isSelected: _calculateSelectedIndex(context) == 1,
                  onTap: () => _onItemTapped(1, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final  location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/profile')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/profile');
        break;
    }
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? Colors.white.withAlpha(2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withAlpha(3),
                width: 1,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
