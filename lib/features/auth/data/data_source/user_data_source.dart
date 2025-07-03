import 'package:hisab_kitab/features/auth/data/model/user_api_model.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';

abstract class IUserDataSource {
  Future<void> registerUser(UserEntity entity);
  Future<String> loginUser(String email, String password);
  Future<UserApiModel> getProfile();
}
