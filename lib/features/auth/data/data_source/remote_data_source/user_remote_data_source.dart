import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/core/network/api_service.dart';
import 'package:hisab_kitab/features/auth/data/data_source/user_data_source.dart';
import 'package:hisab_kitab/features/auth/data/model/login_response_model.dart';
import 'package:hisab_kitab/features/auth/data/model/user_api_model.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<LoginResponseModel> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      debugPrint("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // Parse the full response
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to login: ${response.data['message']}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<String> loginUser(String email, String password) async {
  //   try {
  //     final response = await _apiService.dio.post(
  //       ApiEndpoints.login,
  //       data: {'email': email, 'password': password},
  //     );
  //     if (response.statusCode == 200) {
  //       final str = response.data['token'];
  //       return str;
  //     } else {
  //       throw Exception(response.statusMessage);
  //     }
  //   } on DioException catch (e) {
  //     throw Exception('Failed to login: ${e.message}');
  //   } catch (e) {
  //     throw Exception('Failed to login: $e');
  //   }
  // }

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      final userApiModel = UserApiModel.fromEntity(userData);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to register: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to register: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  @override
  Future<UserApiModel> getProfile() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.profile);

      if (response.statusCode == 200) {
        return UserApiModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to get profile data.');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get profile data: ${e.message}');
    }
  }

  @override
  Future<void> logoutUser() async {
    try {
      await _apiService.dio.post(ApiEndpoints.logout);
    } catch (e) {
      print("Server logout failed, but proceeding with local logout: $e");
    }
  }
}
