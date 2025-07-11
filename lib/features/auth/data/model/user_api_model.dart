import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/shops/data/model/shop_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

List<ShopApiModel> _shopsFromJson(dynamic json) {
  if (json is List) {
    return json
        .map((item) {
          if (item is Map<String, dynamic>) {
            return ShopApiModel.fromJson(item);
          }
          return null;
        })
        .whereType<ShopApiModel>()
        .toList();
  }
  return [];
}

ShopApiModel? _activeShopFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
    return ShopApiModel.fromJson(json);
  }
  return null;
}

List<Map<String, dynamic>> _shopsToJson(List<ShopApiModel> shops) {
  return shops.map((shop) => shop.toJson()).toList();
}

Map<String, dynamic>? _activeShopToJson(ShopApiModel? shop) {
  return shop?.toJson();
}

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fname;
  final String lname;
  final String phone;
  final String email;
  final String? password;

  // Tell the generator to use our helper functions for these fields
  @JsonKey(fromJson: _shopsFromJson, toJson: _shopsToJson)
  final List<ShopApiModel> shops;

  @JsonKey(fromJson: _activeShopFromJson, toJson: _activeShopToJson)
  final ShopApiModel? activeShop;

  const UserApiModel({
    this.userId,
    required this.fname,
    required this.lname,
    required this.phone,
    required this.email,
    this.password,
    this.shops = const [],
    this.activeShop,
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
      shops: shops.map((shopModel) => shopModel.toEntity()).toList(),
      activeShop: activeShop?.toEntity(),
    );
  }

  factory UserApiModel.fromEntity(UserEntity userEntity) {
    return UserApiModel(
      userId: userEntity.userId,
      fname: userEntity.fname,
      lname: userEntity.lname,
      phone: userEntity.phone,
      email: userEntity.email,
      password: userEntity.password,
      shops: userEntity.shops.map((e) => ShopApiModel.fromEntity(e)).toList(),
      activeShop:
          userEntity.activeShop != null
              ? ShopApiModel.fromEntity(userEntity.activeShop!)
              : null,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    fname,
    lname,
    phone,
    email,
    password,
    shops,
    activeShop,
  ];
}
