import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/entity/login_response_entity.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({required this.email, required this.password});

  const LoginUserParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class UserLoginUsecase
    implements UseCaseWithParams<LoginResponseEntity, LoginUserParams> {
  final IUserRepository _repository;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserLoginUsecase({
    required IUserRepository repository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _repository = repository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, LoginResponseEntity>> call(
    LoginUserParams params,
  ) async {
    // Return LoginResponseEntity
    final result = await _repository.loginUser(params.email, params.password);
    return result.fold((failure) => Left(failure), (loginResponseEntity) async {
      // Save token and return the full entity
      await _tokenSharedPrefs.saveToken(loginResponseEntity.token);
      return Right(loginResponseEntity);
    });
  }
}
