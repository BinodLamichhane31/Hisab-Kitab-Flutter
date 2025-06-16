import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser();
  Future<Either<Failure, String>> loginUser(String email, String password);
}
