import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String fname;
  final String lname;
  final String email;
  final String phone;
  final String password;

  const RegisterUserParams({
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.password,
  });

  const RegisterUserParams.initial({
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [fname, lname, email, phone, password];
}

class UserRegisterUsecase
    implements UseCaseWithParams<void, RegisterUserParams> {
  final IUserRepository repository;

  UserRegisterUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) async {
    var user = UserEntity(
      fname: params.fname,
      lname: params.lname,
      email: params.email,
      phone: params.phone,
      password: params.password,
    );
    return await repository.registerUser(user);
  }
}
