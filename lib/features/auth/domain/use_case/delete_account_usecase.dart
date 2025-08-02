import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class DeleteAccountUsecase implements UseCaseWithoutParams<void> {
  final IUserRepository _repository;

  DeleteAccountUsecase(this._repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await _repository.deleteAccount();
  }
}
