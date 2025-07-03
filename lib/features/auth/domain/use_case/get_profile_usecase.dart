import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class GetProfileUsecase {
  final IUserRepository _repository;

  GetProfileUsecase(this._repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getProfile();
  }
}
