import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/constant/hive/hive_table_constant.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String fname;

  @HiveField(2)
  final String lname;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String password;

  UserHiveModel({
    String? userId,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.password,
  }) : userId = userId ?? Uuid().v4();

  const UserHiveModel.initial()
    : userId = '',
      fname = '',
      lname = '',
      email = '',
      phone = '',
      password = '';

  factory UserHiveModel.fromEntity(UserEntity userEntity) {
    return UserHiveModel(
      fname: userEntity.fname,
      lname: userEntity.lname,
      email: userEntity.email,
      phone: userEntity.phone,
      password: userEntity.password,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fname: fname,
      lname: lname,
      email: email,
      phone: phone,
      password: password,
    );
  }

  static List<UserHiveModel> fromEntityList(List<UserEntity> userEntityList) {
    return userEntityList
        .map((userEntity) => UserHiveModel.fromEntity(userEntity))
        .toList();
  }

  @override
  List<Object?> get props => [userId, fname, lname, email, phone, password];
}
