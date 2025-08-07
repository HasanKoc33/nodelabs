import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../entities/movie.dart';
import '../../repositories/movie_repository.dart';
import '../usecase.dart';

@injectable
class GetFavoriteMoviesUseCase implements UseCase<List<Movie>, NoParams> {
  final MovieRepository repository;

  GetFavoriteMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return await repository.getFavoriteMovies();
  }
}
