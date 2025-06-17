import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({required this.email, required this.password});

  const LoginUserParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class UserLoginUsecase implements UseCaseWithParams<String, LoginUserParams> {
  final IUserRepository repository;

  UserLoginUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(LoginUserParams params) async {
    return await repository.loginUser(params.email, params.password);
  }
}
