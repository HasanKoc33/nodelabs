import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nodelabs/core/error/failures.dart';
import 'package:nodelabs/domain/entities/user.dart';
import 'package:nodelabs/domain/repositories/auth_repository.dart';
import 'package:nodelabs/domain/usecases/usecase.dart';

@injectable
class RefreshProfileUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;

  RefreshProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.refreshProfile();
  }
}
