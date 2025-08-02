import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:hisab_kitab/features/auth/domain/entity/login_response_entity.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRemoteRepository({required UserRemoteDataSource userRemoteDataSource})
    : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<Either<Failure, LoginResponseEntity>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final loginResponseModel = await _userRemoteDataSource.loginUser(
        email,
        password,
      );
      return Right(loginResponseModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userRemoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final userApiModel = await _userRemoteDataSource.getProfile();
      return Right(userApiModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      await _userRemoteDataSource.logoutUser();
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    String fname,
    String lname,
  ) async {
    try {
      final userApiModel = await _userRemoteDataSource.updateProfile(
        fname,
        lname,
      );
      return Right(userApiModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await _userRemoteDataSource.changePassword(oldPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _userRemoteDataSource.deleteAccount();
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> uploadProfileImage(
    String imagePath,
  ) async {
    try {
      final userApiModel = await _userRemoteDataSource.uploadProfileImage(
        imagePath,
      );
      return Right(userApiModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
