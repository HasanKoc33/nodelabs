import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nodelabs/core/di/injection.dart';
import 'package:nodelabs/core/services/navigation_service.dart';
import 'package:nodelabs/core/theme/app_theme.dart';
import 'package:nodelabs/domain/entities/movie.dart';
import 'package:nodelabs/domain/entities/user.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_event.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_state.dart';
import 'package:nodelabs/presentation/bloc/profile/profile_bloc.dart';
import 'package:nodelabs/presentation/bloc/profile/profile_event.dart';
import 'package:nodelabs/presentation/bloc/profile/profile_state.dart';
import 'package:nodelabs/presentation/widgets/limited_offer_bottom_sheet.dart';

/// ProfileScreen displays user profile information, favorite movies,
class ProfileScreen extends StatefulWidget {
  /// Creates an instance of [ProfileScreen].
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorite movies when screen initializes
    context.read<ProfileBloc>().add(const ProfileLoadFavoriteMovies());
    // Refresh profile data from API
    context.read<AuthBloc>().add(AuthRefreshProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              // Navigate to login screen when user logs out
              getIt<NavigationService>().goToLogin();
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return _buildProfileContent(context, state.user);
              } else {
                return _buildNotAuthenticatedView(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with back button
          _buildHeader(context),

          // Profile Info Section
          _buildProfileInfo(context, user),

          // Favorite Movies Section
          _buildFavoriteMoviesSection(context),

          // Settings Section
          _buildSettingsSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'profile.title'.tr(),
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                LimitedOfferBottomSheet.show(context);
              },
              label: Text(
                'limitedOffer.title'.tr(),
                style: const TextStyle(fontSize: 12,color: AppTheme.textPrimary),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(Icons.diamond, color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, User user) {
    return ListTile(
      leading: ClipOval(
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          height: 50,
          width: 50,
          child: CachedNetworkImage(
            imageUrl: user.profileImageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return const ColoredBox(
                color: AppTheme.cardBackground,
                child: Icon(
                  Icons.person,
                  color: AppTheme.textSecondary,
                ),
              );
            },
            errorWidget: (context, error, stackTrace) {
              return const ColoredBox(
                color: AppTheme.cardBackground,
                child: Icon(
                  Icons.person,
                  color: AppTheme.textSecondary,
                ),
              );
            },
          ),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'ID: ${user.id}',
        softWrap: true,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 8),
      ),
      trailing: SizedBox(
        width: 120,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            getIt<NavigationService>().goToUploadPhotoBypassShell();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 2),
          ),
          child: Text(
            'uploadPhoto.addPhoto'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteMoviesSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'profile.favoriteMovies'.tr(),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Favorite movies content
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileFavoriteMoviesLoading) {
                return _buildFavoriteMoviesLoading();
              } else if (state is ProfileFavoriteMoviesLoaded) {
                return _buildFavoriteMoviesGrid(state.favoriteMovies);
              } else if (state is ProfileFavoriteMoviesError) {
                return _buildFavoriteMoviesError(state.message);
              } else {
                return _buildFavoriteMoviesEmpty();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteMoviesLoading() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryRed),
        ),
      ),
    );
  }

  Widget _buildFavoriteMoviesGrid(List<Movie> movies) {
    if (movies.isEmpty) {
      return _buildFavoriteMoviesEmpty();
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieCard(movie);
      },
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            child: CachedNetworkImage(
              imageUrl: movie.finalPosterPath,
              fit: BoxFit.fitWidth,
              placeholder: (context, url) {
                return const ColoredBox(
                  color: AppTheme.primaryRed,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.textSecondary),
                    ),
                  ),
                );
              },
              errorWidget: (context, error, stackTrace) {
                return const ColoredBox(
                  color: AppTheme.primaryRed,
                  child: Center(
                    child: Icon(
                      Icons.movie,
                      color: AppTheme.textSecondary,
                      size: 32,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        ListTile(
          title: Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

        ),
      ],
    );
  }

  Widget _buildFavoriteMoviesError(String message) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.errorColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'profile.favoriteMoviesError'.tr(),
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<ProfileBloc>().add(
                  const ProfileRefreshFavoriteMovies(),
                );
              },
              child: Text(
                'app.retry'.tr(),
                style: const TextStyle(color: AppTheme.primaryRed),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteMoviesEmpty() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              color: AppTheme.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'profile.noFavoriteMovies'.tr(),
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'profile.addFavoriteMovies'.tr(),
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildSettingsItem(
            icon: Icons.language_outlined,
            title: 'profile.language'.tr(),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            title: 'auth.logout'.tr(),
            isDestructive: true,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppTheme.errorColor : AppTheme.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildNotAuthenticatedView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_outline,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'profile.loginRequired'.tr(),
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'profile.loginRequiredMessage'.tr(),
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBackground,
          title: Text(
            'auth.logout'.tr(),
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
          content: Text(
            'profile.logoutConfirm'.tr(),
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'app.cancel'.tr(),
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthLogoutRequested());
              },
              child: Text(
                'auth.logout'.tr(),
                style: const TextStyle(color: AppTheme.errorColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBackground,
          title: Text(
            'profile.language'.tr(),
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇹🇷', style: TextStyle(fontSize: 24)),
                title: const Text(
                  'Türkçe',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                onTap: () {
                  context.setLocale(const Locale('tr', 'TR'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                title: const Text(
                  'English',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                onTap: () {
                  context.setLocale(const Locale('en', 'US'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'app.cancel'.tr(),
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          ],
        );
      },
    );
  }

}
