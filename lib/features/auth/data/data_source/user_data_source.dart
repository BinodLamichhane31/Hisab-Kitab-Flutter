import 'package:hisab_kitab/features/auth/data/model/login_response_model.dart';
import 'package:hisab_kitab/features/auth/data/model/user_api_model.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';

abstract class IUserDataSource {
  Future<void> registerUser(UserEntity entity);
  Future<LoginResponseModel> loginUser(String email, String password);
  Future<UserApiModel> getProfile();
  Future<UserApiModel> updateProfile(String fname, String lname);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> deleteAccount();
  Future<UserApiModel> uploadProfileImage(String imagePath);
  Future<void> logoutUser();
}
