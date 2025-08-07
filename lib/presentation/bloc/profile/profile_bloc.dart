import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/services/logger_service.dart';
import '../../../domain/usecases/movies/get_favorite_movies_usecase.dart';
import '../../../domain/usecases/usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetFavoriteMoviesUseCase _getFavoriteMoviesUseCase;
  final LoggerService _logger;

  ProfileBloc(
    this._getFavoriteMoviesUseCase,
    this._logger,
  ) : super(const ProfileInitial()) {
    on<ProfileLoadFavoriteMovies>(_onProfileLoadFavoriteMovies);
    on<ProfileRefreshFavoriteMovies>(_onProfileRefreshFavoriteMovies);
  }

  Future<void> _onProfileLoadFavoriteMovies(
    ProfileLoadFavoriteMovies event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileFavoriteMoviesLoading());
    
    final result = await _getFavoriteMoviesUseCase(NoParams());
    
    result.fold(
      (failure) {
        _logger.error('Failed to load favorite movies: ${failure.message}');
        emit(ProfileFavoriteMoviesError(failure.message));
      },
      (movies) {
        _logger.info('Loaded ${movies.length} favorite movies');
        emit(ProfileFavoriteMoviesLoaded(movies));
      },
    );
  }

  Future<void> _onProfileRefreshFavoriteMovies(
    ProfileRefreshFavoriteMovies event,
    Emitter<ProfileState> emit,
  ) async {
    // Keep current state while refreshing
    final result = await _getFavoriteMoviesUseCase(NoParams());
    
    result.fold(
      (failure) {
        _logger.error('Failed to refresh favorite movies: ${failure.message}');
        emit(ProfileFavoriteMoviesError(failure.message));
      },
      (movies) {
        _logger.info('Refreshed ${movies.length} favorite movies');
        emit(ProfileFavoriteMoviesLoaded(movies));
      },
    );
  }
}
