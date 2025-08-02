import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class UpdateProfileParams extends Equatable {
  final String fname;
  final String lname;

  const UpdateProfileParams({required this.fname, required this.lname});

  @override
  List<Object?> get props => [fname, lname];
}

class UpdateProfileUsecase
    implements UseCaseWithParams<UserEntity, UpdateProfileParams> {
  final IUserRepository _repository;

  UpdateProfileUsecase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await _repository.updateProfile(params.fname, params.lname);
  }
}
