import 'package:dartz/dartz.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await _sharedPreferences.setString("token", token);
      return Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: "Failed to save token: $e"),
      );
    }
  }

  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      return Right(token);
    } catch (e) {
      return Left(SharedPreferencesFailure(message: "Failed to get token: $e"));
    }
  }

  Future<Either<Failure, void>> clearToken() async {
    try {
      await _sharedPreferences.remove('token');
      return const Right(null);
    } catch (e) {
      return Left(
        SharedPreferencesFailure(message: "Failed to clear token: $e"),
      );
    }
  }
}
