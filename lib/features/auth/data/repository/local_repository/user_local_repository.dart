import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/data/data_source/local_data_source/user_local_data_source.dart';
import 'package:hisab_kitab/features/auth/domain/entity/login_response_entity.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDataSource _userLocalDataSource;

  UserLocalRepository({required UserLocalDataSource userLocalDataSource})
    : _userLocalDataSource = userLocalDataSource;
  // @override
  // Future<Either<Failure, LoginResponseEntity>> loginUser(
  //   String email,
  //   String password,
  // ) async {
  //   try {
  //     final result = await _userLocalDataSource.loginUser(email, password);
  //     return Right(result);
  //   } catch (e) {
  //     return Left(LocalDatabaseFailure(message: "Login Failed: $e"));
  //   }
  // }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDataSource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Registration Failed: $e"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> loginUser(
    String email,
    String password,
  ) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logoutUser() {
    // TODO: implement logoutUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    String fname,
    String lname,
  ) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> uploadProfileImage(String imagePath) {
    // TODO: implement uploadProfileImage
    throw UnimplementedError();
  }
}
