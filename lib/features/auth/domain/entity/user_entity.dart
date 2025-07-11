import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String fname;
  final String lname;
  final String email;
  final String phone;
  final String password;
  final List<ShopEntity> shops;
  final ShopEntity? activeShop;

  const UserEntity({
    this.userId,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.password,
    this.shops = const [],
    this.activeShop,
  });

  @override
  List<Object?> get props => [
    userId,
    fname,
    lname,
    email,
    phone,
    password,
    shops,
    activeShop,
  ];
}
