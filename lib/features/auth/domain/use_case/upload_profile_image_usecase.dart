import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class UploadProfileImageParams extends Equatable {
  final String imagePath;

  const UploadProfileImageParams({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class UploadProfileImageUsecase
    implements UseCaseWithParams<UserEntity, UploadProfileImageParams> {
  final IUserRepository _repository;

  UploadProfileImageUsecase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(
    UploadProfileImageParams params,
  ) async {
    return await _repository.uploadProfileImage(params.imagePath);
  }
}
