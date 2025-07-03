import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fname;
  final String lname;
  final String phone;
  final String email;
  final String? password;

  const UserApiModel({
    this.userId,
    required this.fname,
    required this.lname,
    required this.phone,
    required this.email,
    this.password,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fname: fname,
      lname: lname,
      email: email,
      phone: phone,
      password: password ?? "",
    );
  }

  factory UserApiModel.fromEntity(UserEntity userEntity) {
    final user = UserApiModel(
      fname: userEntity.fname,
      lname: userEntity.lname,
      phone: userEntity.phone,
      email: userEntity.email,
      password: userEntity.password,
    );
    return user;
  }

  @override
  List<Object?> get props => [userId, fname, lname, phone, email, password];
}
