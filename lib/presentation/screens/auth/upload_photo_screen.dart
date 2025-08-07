import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodelabs/core/di/injection.dart';
import 'package:nodelabs/core/services/navigation_service.dart';
import 'package:nodelabs/core/theme/app_theme.dart';
import 'package:nodelabs/domain/usecases/auth/upload_photo_usecase.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_event.dart';

/// UploadPhotoScreen allows users to upload a profile photo.
class UploadPhotoScreen extends StatefulWidget {
  /// Creates an instance of [UploadPhotoScreen].
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File? _selectedImage;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } on Exception catch (e) {
      _showError('${'errors.photoSelectionError'.tr()}: $e');
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final uploadPhotoUseCase = getIt<UploadPhotoUseCase>();
      final result = await uploadPhotoUseCase(
        UploadPhotoParams(file: _selectedImage!),
      );

      result.fold(
        (failure) {
          _showError('${'errors.photoUploadError'.tr()}: ${failure.message}');
        },
        (photoUrl) {
          _showSuccess('errors.photoUploadSuccess'.tr());
          context.read<AuthBloc>().add(AuthRefreshProfileRequested());
          // Navigate back to profile after successful upload
          Future.delayed(const Duration(seconds: 1), () {
            getIt<NavigationService>().goToProfile();
          });
        },
      );
    } on Exception catch (e) {
      _showError('Beklenmeyen hata: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.errorColor),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.successColor),
    );
  }

  void _skipForNow() {
    getIt<NavigationService>().goToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: _isUploading ? null : () => getIt<NavigationService>().goToProfile(),
        ),
        title: Text(
          'uploadPhoto.title'.tr(),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: PopScope(
        canPop: false,
       onPopInvokedWithResult: (_,__) async{
         getIt<NavigationService>().goToProfile();
          return Future.value(false);
        },
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      'uploadPhoto.uploadTitle'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'uploadPhoto.uploadDescription'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Photo Upload Area
                    GestureDetector(
                      onTap: _isUploading ? null : _pickImage,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderColor, width: 2),
                        ),
                        child:
                            _selectedImage != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 48,
                                      color: AppTheme.textSecondary,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'uploadPhoto.addPhoto'.tr(),
                                      style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Upload Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _selectedImage != null && !_isUploading
                                ? _uploadPhoto
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBackgroundColor: AppTheme.borderColor,
                        ),
                        child:
                            _isUploading
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
                                  'uploadPhoto.continue'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Skip Button
                    TextButton(
                      onPressed: _isUploading ? null : _skipForNow,
                      child: Text(
                        'uploadPhoto.skip'.tr(),
                        style: TextStyle(
                          color: _isUploading ? AppTheme.borderColor : AppTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Loading Overlay
            if (_isUploading)
              ColoredBox(
                color: Colors.black.withOpacity(0.3),
                child:  Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryRed),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'uploadPhoto.uploading'.tr(),
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
