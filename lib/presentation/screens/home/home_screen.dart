import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nodelabs/core/di/injection.dart';
import 'package:nodelabs/core/services/firebase_service.dart';
import 'package:nodelabs/core/services/logger_service.dart';
import 'package:nodelabs/core/theme/app_theme.dart';
import 'package:nodelabs/domain/entities/movie.dart';
import 'package:nodelabs/presentation/bloc/movies/movies_bloc.dart';
import 'package:nodelabs/presentation/bloc/movies/movies_event.dart';
import 'package:nodelabs/presentation/bloc/movies/movies_state.dart';
import 'package:nodelabs/presentation/widgets/home_movie_widget.dart';
import 'package:nodelabs/presentation/widgets/movie_error_widget.dart';
import 'package:nodelabs/presentation/widgets/movie_shimmer.dart';

/// HomeScreen displays a vertical page view of movies with infinite scrolling.
class HomeScreen extends StatefulWidget {
  /// Creates a new instance of HomeScreen.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  bool _isLoadingMore = false;
  final Set<String> _loadingFavorites = {}; // Loading durumundaki film ID'leri
  late final LoggerService _logger;

  @override
  void initState() {
    super.initState();
    _logger = getIt<LoggerService>();
    _loadMovies();
    _setupPageListener();

    // Log screen view
    try {
      getIt<FirebaseService>().logScreenView(screenName: 'Home');
    } on Exception catch (e) {
      _logger.error('Firebase service not available', e);
      // Firebase service not available
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _setupPageListener() {
    _pageController.addListener(() {
      final moviesBloc = context.read<MoviesBloc>();
      final state = moviesBloc.state;
      var movieCount = 0;
      if (state is MoviesLoaded) {
        movieCount = state.movies.length;
      } else if (state is MoviesLoadingMore) {
        movieCount = state.movies.length;
      } else if (state is MoviesError) {
        movieCount = state.movies.length;
      }
      // Son 2 filme gelince yeni filmler yükle
      if (!_isLoadingMore &&
          movieCount > 0 &&
          _pageController.page != null &&
          _pageController.page! >= movieCount - 3) {
        _loadMoreMovies();
      }
    });
  }

  void _loadMovies() {
    context.read<MoviesBloc>().add(const MoviesLoadRequested());
  }

  void _loadMoreMovies() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      context.read<MoviesBloc>().add(MoviesLoadMoreRequested());
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoadingMore = false;
    });
    context.read<MoviesBloc>().add(MoviesRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: BlocConsumer<MoviesBloc, MoviesState>(
          listener: (context, state) {
            if (state is MoviesLoaded || state is MoviesError) {
              setState(() {
                _isLoadingMore = false;
                // Clear loading favorites when movies are updated
                _loadingFavorites.clear();
              });
            }

            if (state is MoviesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is MoviesLoading) {
              return const MovieShimmer();
            }

            if (state is MoviesError && state.movies.isEmpty) {
              return MovieErrorWidget(
                message: state.message,
                onRetry: _loadMovies,
              );
            }

            if (state is MoviesLoaded ||
                state is MoviesLoadingMore ||
                state is MoviesError) {
              final movies =
                  state is MoviesLoaded
                      ? state.movies
                      : state is MoviesLoadingMore
                      ? state.movies
                      : (state as MoviesError).movies;

              return _buildMoviesGrid(movies);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMoviesGrid(List<Movie> movies) {
    return RefreshIndicator(
      onRefresh: () async => _onRefresh(),
      backgroundColor: AppTheme.cardBackground,
      color: AppTheme.primaryRed,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return HomeMovieWidget(
            movie: movie,
            loadingFavorites: _loadingFavorites,
            logger: _logger,
            onFavoriteToggled: () {
              setState(() {
                _loadingFavorites.add(movie.id);
              });
            },
          );
        },
      ),
    );
  }
}
