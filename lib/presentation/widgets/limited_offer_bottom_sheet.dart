import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A bottom sheet widget that displays a limited time
/// offer for premium membership with token packages.
class LimitedOfferBottomSheet extends StatelessWidget {
  /// Creates a new instance of [LimitedOfferBottomSheet].
  const LimitedOfferBottomSheet({super.key});

  /// Displays the bottom sheet in the given [context].
  static void show(BuildContext context) {
    // Use root navigator to show above bottom navigation bar
    Navigator.of(context, rootNavigator: true).push(
      ModalBottomSheetRoute<void>(
        builder: (context) => const LimitedOfferBottomSheet(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        useSafeArea: false,
        enableDrag: true,
        isDismissible: true,
        elevation: 0,
        modalBarrierColor: Colors.black.withOpacity(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.70 ,
      width: screenWidth,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          // Top red gradient
          Positioned(
            top: -(MediaQuery.of(context).size.height * .1),
            right: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.red,
                    Colors.transparent,
                  ],
                  stops: [0.0, 1.0],
                  radius: 0.9,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 24),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          // Bottom red gradient
          Positioned(
            bottom: -(MediaQuery.of(context).size.height * .1),
            right: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.red,
                    Colors.transparent,
                  ],
                  stops: [0.0, 1.0],
                  radius: 0.9,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 24),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          // Drag handle
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Main content
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 20,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  top: 20,
                  bottom: MediaQuery.of(context).padding.bottom + 20,
                ),
                child: Column(
                  children: [

                    // Title
                    Text(
                      'limitedOffer.title'.tr(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Subtitle
                    Text(
                      'limitedOffer.subtitle'.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Bonus Features Title
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'limitedOffer.bonusTitle'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildBonusFeature(
                                    Icons.diamond_outlined,
                                    'limitedOffer.premiumAccount'.tr(),
                                    const Color(0xFFE91E63),
                                    const Color(0xFF70070c),
                                    screenWidth,
                                  ),
                                  _buildBonusFeature(
                                    Icons.favorite,
                                    'limitedOffer.moreMatches'.tr(),
                                    const Color(0xFFE91E63),
                                    const Color(0xFF70070c),
                                    screenWidth,
                                  ),
                                  _buildBonusFeature(
                                    Icons.visibility,
                                    'limitedOffer.highlight'.tr(),
                                    const Color(0xFFE91E63),
                                    const Color(0xFF70070c),
                                    screenWidth,
                                  ),
                                  _buildBonusFeature(
                                    Icons.favorite_border,
                                    'limitedOffer.moreLikes'.tr(),
                                    const Color(0xFFE91E63),
                                    const Color(0xFF70070c),
                                    screenWidth,
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),
                    // Package Selection Title
                    Text(
                      'limitedOffer.selectPackageTitle'.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // Token Packages
                    Row(
                      children: [
                        Expanded(
                          child: _buildTokenPackage(
                            discount: '+10%',
                            originalTokens: '200',
                            bonusTokens: '330',
                            price: '₺99.99',
                            subtitle: 'limitedOffer.weeklyPerToken'.tr(),
                            color: const Color(0xFF70060b),
                            screenHeight: screenHeight,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: _buildTokenPackage(
                            discount: '+70%',
                            originalTokens: '2.000',
                            bonusTokens: '3.375',
                            price: '₺799.99',
                            subtitle: 'limitedOffer.weeklyPerToken'.tr(),
                            color: const Color(0xff6345d8),
                            isPopular: true,
                            screenHeight: screenHeight,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: _buildTokenPackage(
                            discount: '+35%',
                            originalTokens: '1.000',
                            bonusTokens: '1.350',
                            price: '₺399.99',
                            subtitle: 'limitedOffer.weeklyPerToken'.tr(),
                            color: const Color(0xFF70060b),
                            screenHeight: screenHeight,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        top: 10
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'limitedOffer.purchaseComingSoon'.tr(),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'limitedOffer.viewAllTokensButton'.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusFeature(
    IconData icon,
    String text,
    Color color, Color bgColor,
    double screenWidth,
  ) {
    final iconSize = screenWidth * 0.15;
    return Column(
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 0.2,
              ),
              boxShadow: [
              BoxShadow(color: Colors.white),
      BoxShadow(
        color: bgColor,
        spreadRadius: -1,
        blurRadius: 8.0,
      ),
            ],
          ),
          child: Icon(
            icon,
            color: color,
            size: iconSize * 0.45,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: screenWidth * 0.028,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTokenPackage({
    required String discount,
    required String originalTokens,
    required String bonusTokens,
    required String price,
    required String subtitle,
    required Color color,
    required double screenHeight,
    bool isPopular = false,
  }) {
    return SizedBox(
      height: screenHeight * 0.22,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 6,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.8),
                    Color(0xFFCC1111),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.white),
                  BoxShadow(
                    color: color,
                    spreadRadius: -10,
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            originalTokens,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white.withOpacity(0.8),
                              decorationThickness: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Bonus tokens (large)
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              bonusTokens,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                                height: 1.0,
                              ),
                            ),
                          ),
                          // Jeton label
                          Text(
                            'limitedOffer.tokenLabel'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider line
                    Container(
                      height: 0.8,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 8),
                    // Price
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    // Subtitle
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.white.withAlpha(250)),
                    BoxShadow(
                      color: color,
                      spreadRadius: -.2,
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Text(
                  discount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
