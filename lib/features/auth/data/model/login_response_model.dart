import 'package:hisab_kitab/features/auth/data/model/user_api_model.dart';
import 'package:hisab_kitab/features/auth/domain/entity/login_response_entity.dart';
import 'package:hisab_kitab/features/shops/data/model/shop_api_model.dart';

class LoginResponseModel {
  final String token;
  final UserApiModel user;
  final List<ShopApiModel> shops;
  final String? currentShopId;

  LoginResponseModel({
    required this.token,
    required this.user,
    required this.shops,
    this.currentShopId,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return LoginResponseModel(
      token: json["token"],
      user: UserApiModel.fromJson(data["user"]),
      shops: List<ShopApiModel>.from(
        data["shops"].map((x) => ShopApiModel.fromJson(x)),
      ),
      currentShopId: data["currentShopId"],
    );
  }

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      token: token,
      user: user.toEntity(),
      shops: shops.map((e) => e.toEntity()).toList(),
      currentShopId: currentShopId,
    );
  }
}
