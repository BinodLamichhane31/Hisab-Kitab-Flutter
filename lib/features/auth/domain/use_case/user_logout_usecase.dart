import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';

class UserLogoutUsecase implements UseCaseWithoutParams<void> {
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLogoutUsecase(this._tokenSharedPrefs);

  @override
  Future<Either<Failure, void>> call() async {
    return await _tokenSharedPrefs.clearToken();
  }
}
