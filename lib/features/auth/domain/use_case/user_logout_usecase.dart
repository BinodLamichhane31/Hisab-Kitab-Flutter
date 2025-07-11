import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class UserLogoutUsecase implements UseCaseWithoutParams<void> {
  final IUserRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLogoutUsecase(this._tokenSharedPrefs, this._repository);

  @override
  Future<Either<Failure, void>> call() async {
    final serverResult = await _repository.logoutUser();
    await _tokenSharedPrefs.clearToken();
    return serverResult;
  }
}
