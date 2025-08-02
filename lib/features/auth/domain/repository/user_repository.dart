import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/domain/entity/login_response_entity.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);
  Future<Either<Failure, LoginResponseEntity>> loginUser(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, UserEntity>> updateProfile(String fname, String lname);
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  );
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, UserEntity>> uploadProfileImage(String imagePath);
  Future<Either<Failure, void>> logoutUser();
}
