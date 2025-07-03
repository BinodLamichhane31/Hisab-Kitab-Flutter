import 'package:hisab_kitab/core/network/hive_service.dart';
import 'package:hisab_kitab/features/auth/data/data_source/user_data_source.dart';
import 'package:hisab_kitab/features/auth/data/model/user_api_model.dart';
import 'package:hisab_kitab/features/auth/data/model/user_hive_model.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final loginUser = await _hiveService.loginUser(email, password);
      if (loginUser != null && loginUser.password == password) {
        return "Login Successful";
      } else {
        return "Invalid Credentials";
      }
    } catch (e) {
      throw Exception("Login Failed: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity entity) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(entity);
      await _hiveService.registerUser(userHiveModel);
    } catch (e) {
      throw Exception("Registration Failed: $e");
    }
  }

  @override
  Future<UserApiModel> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }
}
