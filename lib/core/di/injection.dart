import 'package:get_it/get_it.dart';

// Core Services
import 'package:nodelabs/core/services/firebase_service.dart';
import 'package:nodelabs/core/services/logger_service.dart';
import 'package:nodelabs/core/services/navigation_service.dart';
import 'package:nodelabs/core/services/storage_service.dart';

// Network
import 'package:nodelabs/core/network/dio_client.dart';
import 'package:nodelabs/core/network/network_info.dart';

// Data Sources
import 'package:nodelabs/data/datasources/local/auth_local_datasource.dart';
import 'package:nodelabs/data/datasources/remote/auth_remote_datasource.dart';
import 'package:nodelabs/data/datasources/remote/movie_remote_datasource.dart';

// Repositories
import 'package:nodelabs/domain/repositories/auth_repository.dart';
import 'package:nodelabs/domain/repositories/movie_repository.dart';
import 'package:nodelabs/data/repositories/auth_repository_impl.dart';
import 'package:nodelabs/data/repositories/movie_repository_impl.dart';

// UseCases
import 'package:nodelabs/domain/usecases/auth/login_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/register_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/logout_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/refresh_profile_usecase.dart';
import 'package:nodelabs/domain/usecases/auth/upload_photo_usecase.dart';
import 'package:nodelabs/domain/usecases/movie/get_movies_usecase.dart';
import 'package:nodelabs/domain/usecases/movie/add_to_favorites_usecase.dart';
import 'package:nodelabs/domain/usecases/movies/get_favorite_movies_usecase.dart';

// Blocs
import 'package:nodelabs/presentation/bloc/auth/auth_bloc.dart';
import 'package:nodelabs/presentation/bloc/movies/movies_bloc.dart';
import 'package:nodelabs/presentation/bloc/profile/profile_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Register core services manually
  if (!getIt.isRegistered<StorageService>()) {
    getIt.registerLazySingleton<StorageService>(() => StorageService());
  }

  if (!getIt.isRegistered<NavigationService>()) {
    getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  }

  if (!getIt.isRegistered<FirebaseService>()) {
    getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());
  }

  if (!getIt.isRegistered<LoggerService>()) {
    getIt.registerLazySingleton<LoggerService>(() => LoggerService());
  }

  // Register network and data sources
  if (!getIt.isRegistered<DioClient>()) {
    getIt.registerLazySingleton<DioClient>(() => DioClient(
      getIt<LoggerService>(),
      getIt<StorageService>(),
    ));
  }

  if (!getIt.isRegistered<NetworkInfo>()) {
    getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  }

  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt<DioClient>().dio),
    );
  }

  if (!getIt.isRegistered<AuthLocalDataSource>()) {
    getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(getIt<StorageService>()),
    );
  }

  if (!getIt.isRegistered<MovieRemoteDataSource>()) {
    getIt.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSource(getIt<DioClient>().dio),
    );
  }

  // Register repositories
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        localDataSource: getIt<AuthLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ),
    );
  }

  if (!getIt.isRegistered<MovieRepository>()) {
    getIt.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(
        remoteDataSource: getIt<MovieRemoteDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ),
    );
  }

  // Register use cases
  if (!getIt.isRegistered<LoginUseCase>()) {
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<RegisterUseCase>()) {
    getIt.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<LogoutUseCase>()) {
    getIt.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<RefreshProfileUseCase>()) {
    getIt.registerLazySingleton<RefreshProfileUseCase>(
      () => RefreshProfileUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<UploadPhotoUseCase>()) {
    getIt.registerLazySingleton<UploadPhotoUseCase>(
      () => UploadPhotoUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<GetMoviesUseCase>()) {
    getIt.registerLazySingleton<GetMoviesUseCase>(
      () => GetMoviesUseCase(getIt<MovieRepository>()),
    );
  }

  if (!getIt.isRegistered<AddToFavoritesUseCase>()) {
    getIt.registerLazySingleton<AddToFavoritesUseCase>(
      () => AddToFavoritesUseCase(getIt<MovieRepository>()),
    );
  }

  if (!getIt.isRegistered<GetFavoriteMoviesUseCase>()) {
    getIt.registerLazySingleton<GetFavoriteMoviesUseCase>(
      () => GetFavoriteMoviesUseCase(getIt<MovieRepository>()),
    );
  }

  // Register blocs
  if (!getIt.isRegistered<AuthBloc>()) {
    getIt.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        getIt<AuthRepository>(),
        getIt<LoginUseCase>(),
        getIt<RegisterUseCase>(),
        getIt<LogoutUseCase>(),
        getIt<RefreshProfileUseCase>(),
        getIt<LoggerService>(),
      ),
    );
  }

  if (!getIt.isRegistered<MoviesBloc>()) {
    getIt.registerLazySingleton<MoviesBloc>(
      () => MoviesBloc(
        getIt<GetMoviesUseCase>(),
        getIt<AddToFavoritesUseCase>(),
        getIt<LoggerService>(),
      ),
    );
  }

  if (!getIt.isRegistered<ProfileBloc>()) {
    getIt.registerLazySingleton<ProfileBloc>(
      () => ProfileBloc(
        getIt<GetFavoriteMoviesUseCase>(),
        getIt<LoggerService>(),
      ),
    );
  }

  // Initialize storage service
  await getIt<StorageService>().init();
}
