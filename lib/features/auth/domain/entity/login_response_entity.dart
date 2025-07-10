import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class LoginResponseEntity {
  final String token;
  final UserEntity user;
  final List<ShopEntity> shops;
  final String? currentShopId;

  LoginResponseEntity({
    required this.token,
    required this.user,
    required this.shops,
    this.currentShopId,
  });
}
