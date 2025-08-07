import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

@injectable
class UploadPhotoUseCase implements UseCase<String, UploadPhotoParams> {
  final AuthRepository repository;

  UploadPhotoUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadPhotoParams params) async {
    return await repository.uploadPhoto(params.file);
  }
}

class UploadPhotoParams extends Equatable {
  final File file;

  const UploadPhotoParams({required this.file});

  @override
  List<Object> get props => [file];
}
