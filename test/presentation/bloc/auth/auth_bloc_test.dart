import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/core/services/firebase_service.dart';
import 'package:nodelabs/domain/entities/user.dart';
import 'package:nodelabs/domain/usecases/usecase.dart';
import 'package:nodelabs/domain/usecases/auth/login_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/register_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/logout_usecase.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_event.dart';
import 'package:nodelabs/presentation/bloc/auth/auth_state.dart';
import '../../../helpers/test_helper.dart';
import '../../../helpers/test_data.dart';

// Use centralized mocks from test_helper.dart
// MockLoginUseCase, MockRegisterUseCase, MockLogoutUseCase are in test_helper.dart

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockRefreshProfileUseCase mockRefreshProfileUseCase;
    late MockLoggerService mockLoggerService;
    late MockFirebaseService mockFirebaseService;

    setUp(() {
      // Setup GetIt for FirebaseService
      final getIt = GetIt.instance;
      if (getIt.isRegistered<FirebaseService>()) {
        getIt.unregister<FirebaseService>();
      }
      mockFirebaseService = MockFirebaseService();
      getIt.registerLazySingleton<FirebaseService>(() => mockFirebaseService);
      mockAuthRepository = MockAuthRepository();
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockRefreshProfileUseCase = MockRefreshProfileUseCase();
      mockLoggerService = MockLoggerService();

      // Register fallback values for custom parameter types
      registerFallbackValue(LoginParams(email: '', password: ''));
      registerFallbackValue(RegisterParams(name: '', email: '', password: ''));
      registerFallbackValue(NoParams());

      authBloc = AuthBloc(
        mockAuthRepository,
        mockLoginUseCase,
        mockRegisterUseCase,
        mockLogoutUseCase,
        mockRefreshProfileUseCase,
        mockLoggerService,
      );
    });

    tearDown(() {
      // Cleanup GetIt registration
      final getIt = GetIt.instance;
      if (getIt.isRegistered<FirebaseService>()) {
        getIt.unregister<FirebaseService>();
      }
    });

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when user is logged in',
        build: () {
          when(() => mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => const Right(true));
          when(() => mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => const Right(TestData.testUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [
          AuthLoading(),
          const AuthAuthenticated(TestData.testUser),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.isLoggedIn()).called(1);
          verify(() => mockAuthRepository.getCurrentUser()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when user is not logged in',
        build: () {
          when(() => mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => const Right(false));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [
          AuthLoading(),
          AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.isLoggedIn()).called(1);
          verifyNever(() => mockAuthRepository.getCurrentUser());
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when isLoggedIn fails',
        build: () {
          when(() => mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [
          AuthLoading(),
          AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(() => mockAuthRepository.isLoggedIn()).called(1);
          verify(() => mockLoggerService.error(any<String>())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthUnauthenticated] when getCurrentUser returns null',
        build: () {
          when(() => mockAuthRepository.isLoggedIn())
              .thenAnswer((_) async => const Right(true));
          when(() => mockAuthRepository.getCurrentUser())
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [
          AuthLoading(),
          AuthUnauthenticated(),
        ],
      );
    });

    group('AuthLoginRequested', () {
      const email = 'test@example.com';
      const password = 'password123';

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthAuthenticated] when login succeeds',
        build: () {
          when(() => mockLoginUseCase.call(any<LoginParams>()))
              .thenAnswer((_) async => const Right(TestData.testUser));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLoginRequested(email: email, password: password)),
        expect: () => [
          AuthLoading(),
          const AuthAuthenticated(TestData.testUser),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase.call(any<LoginParams>())).called(1);
          verify(() => mockLoggerService.info(any<String>())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when login fails',
        build: () {
          when(() => mockLoginUseCase.call(any<LoginParams>()))
              .thenAnswer((_) async => const Left(AuthFailure('Invalid credentials')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLoginRequested(email: email, password: password)),
        expect: () => [
          AuthLoading(),
          const AuthError('Invalid credentials'),
        ],
        verify: (_) {
          verify(() => mockLoginUseCase.call(any<LoginParams>())).called(1);
          verify(() => mockLoggerService.error(any<String>())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'should emit [AuthLoading, AuthError] when network error occurs',
        build: () {
          when(() => mockLoginUseCase.call(any<LoginParams>()))
              .thenAnswer((_) async => const Left(NetworkFailure('No internet connection')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthLoginRequested(email: email, password: password)),
        expect: () => [
          AuthLoading(),
          const AuthError('No internet connection'),
        ],
      );
    });

    group('AuthRegisterRequested', () {
      const testParams = RegisterParams(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );
      const testUser = User(
        id: '67bc8d58d9ec4d40040b81b6',
        email: 'test@example.com',
        name: 'Test User',
        profileImageUrl: 'https://example.com/profile.jpg',
        favoriteMovies: ['1', '2', '3'],
      );

      test('should call register usecase with correct parameters', () async {
        // arrange
        when(() => mockRegisterUseCase(testParams))
            .thenAnswer((_) async => const Right(testUser));

        // act
        authBloc.add(const AuthRegisterRequested(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        ));
        
        await Future.delayed(const Duration(milliseconds: 100));

        // assert
        verify(() => mockRegisterUseCase(testParams)).called(1);
      });

      test('should call register usecase when register fails', () async {
        // arrange
        when(() => mockRegisterUseCase(testParams))
            .thenAnswer((_) async => const Left(AuthFailure('Email already exists')));

        // act
        authBloc.add(const AuthRegisterRequested(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        ));
        
        await Future.delayed(const Duration(milliseconds: 100));

        // assert
        verify(() => mockRegisterUseCase(testParams)).called(1);
      });
    });

    group('AuthLogoutRequested', () {
      test('should call logout usecase when logout requested', () async {
        // arrange
        when(() => mockLogoutUseCase.call(any<NoParams>()))
            .thenAnswer((_) async => const Right(null));

        // act
        authBloc.add(AuthLogoutRequested());
        await Future.delayed(const Duration(milliseconds: 100));

        // assert
        verify(() => mockLogoutUseCase.call(any<NoParams>())).called(1);
      });
    });

    group('AuthRefreshTokenRequested', () {
      test('should call refresh token when requested', () async {
        // arrange
        when(() => mockAuthRepository.refreshToken())
            .thenAnswer((_) async => const Right(null));

        // act
        authBloc.add(AuthRefreshTokenRequested());
        await Future.delayed(const Duration(milliseconds: 100));

        // assert
        verify(() => mockAuthRepository.refreshToken()).called(1);
      });
    });
  });
}
