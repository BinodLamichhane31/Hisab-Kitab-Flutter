import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class ChangePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class ChangePasswordUsecase
    implements UseCaseWithParams<void, ChangePasswordParams> {
  final IUserRepository _repository;

  ChangePasswordUsecase(this._repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return await _repository.changePassword(
      params.oldPassword,
      params.newPassword,
    );
  }
}
