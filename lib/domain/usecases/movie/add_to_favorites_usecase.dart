import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../repositories/movie_repository.dart';
import '../usecase.dart';

@injectable
class AddToFavoritesUseCase implements UseCase<void, AddToFavoritesParams> {
  final MovieRepository repository;

  AddToFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToFavoritesParams params) async {
    return await repository.addToFavorites(params.movieId);
  }
}

class AddToFavoritesParams extends Equatable {
  final String movieId;

  const AddToFavoritesParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
