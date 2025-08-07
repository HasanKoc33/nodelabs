import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../repositories/movie_repository.dart';
import '../usecase.dart';

@injectable
class GetMoviesUseCase implements UseCase<MovieListResult, GetMoviesParams> {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, MovieListResult>> call(GetMoviesParams params) async {
    return await repository.getMovies(params.page);
  }
}

class GetMoviesParams extends Equatable {
  final int page;

  const GetMoviesParams({required this.page});

  @override
  List<Object> get props => [page];
}
