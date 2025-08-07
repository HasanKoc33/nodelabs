import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, User>> updateUserProfile(User user);
  Future<Either<Failure, String>> uploadProfileImage(String imagePath);
  Future<Either<Failure, void>> deleteAccount();
}
