import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nodelabs/core/di/injection.dart';
import 'package:nodelabs/core/services/firebase_service.dart';
import 'package:nodelabs/core/services/logger_service.dart';
import 'package:nodelabs/domain/repositories/auth_repository.dart';
import 'package:nodelabs/domain/usecases/auth/login_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/logout_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/refresh_profile_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/register_usecase.dart';
import 'package:nodelabs/domain/usecases/usecase.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_event.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_state.dart';

/// Bloc for handling authentication events and states
@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {

  /// Creates an instance of [AuthBloc].
  AuthBloc(
    this._authRepository,
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._refreshProfileUseCase,
    this._logger,
  ) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthRefreshTokenRequested>(_onAuthRefreshTokenRequested);
    on<AuthRefreshProfileRequested>(_onAuthRefreshProfileRequested);
  }
  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final RefreshProfileUseCase _refreshProfileUseCase;
  final LoggerService _logger;

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final isLoggedInResult = await _authRepository.isLoggedIn();
    await isLoggedInResult.fold(
      (failure) async {
        _logger.error('Auth check failed: ${failure.message}');
        emit(AuthUnauthenticated());
      },
      (isLoggedIn) async {
        if (isLoggedIn) {
          final userResult = await _authRepository.getCurrentUser();
          userResult.fold(
            (failure) {
              _logger.error('Get current user failed: ${failure.message}');
              emit(AuthUnauthenticated());
            },
            (user) {
              if (user != null) {
                emit(AuthAuthenticated(user));
              } else {
                emit(AuthUnauthenticated());
              }
            },
          );
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final params = LoginParams(email: event.email, password: event.password);
    final result = await _loginUseCase(params);
    
    result.fold(
      (failure) {
        _logger.error('Login failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        _logger.info('Login successful for user: ${user.email}');
        
        // Log analytics event
        try {
          getIt<FirebaseService>().logLogin('email');
          getIt<FirebaseService>().setUserId(user.id);
        } on Exception catch (e) {
          _logger.error('Firebase service error during login: $e');
          // Firebase service not available
        }
        
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final params = RegisterParams(
      name: event.name,
      email: event.email,
      password: event.password,
    );
    final result = await _registerUseCase(params);
    
    result.fold(
      (failure) {
        _logger.error('Register failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        _logger.info('Register successful for user: ${user.email}');
        
        // Log analytics event
        try {
          getIt<FirebaseService>().logSignUp('email');
          getIt<FirebaseService>().setUserId(user.id);
        } on Exception catch (e) {
          _logger.error('Firebase service error during registration: $e');
          // Firebase service not available
        }
        
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await _logoutUseCase(NoParams());
    
    result.fold(
      (failure) {
        _logger.error('Logout failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (_) {
        _logger.info('Logout successful');
        emit(AuthUnauthenticated());
      },
    );
  }

  Future<void> _onAuthRefreshTokenRequested(
    AuthRefreshTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _authRepository.refreshToken();
    
    result.fold(
      (failure) {
        _logger.error('Token refresh failed: ${failure.message}');
        emit(AuthUnauthenticated());
      },
      (_) {
        _logger.info('Token refresh successful');
        // Keep current state, just refresh token in background
      },
    );
  }

  Future<void> _onAuthRefreshProfileRequested(
    AuthRefreshProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _refreshProfileUseCase(NoParams());
    
    result.fold(
      (failure) {
        _logger.error('Profile refresh failed: ${failure}');
        // Don't change state on failure, keep current user
      },
      (user) {
        _logger.info('Profile refresh successful');
        // Update state with fresh user data
        if (state is AuthAuthenticated) {
          emit(AuthAuthenticated(user));
        }
      },
    );
  }
}
