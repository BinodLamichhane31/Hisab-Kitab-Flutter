import 'package:equatable/equatable.dart';

class ShopEntity extends Equatable {
  final String? shopId;
  final String shopName;
  final String? address;
  final String? contactNumber;
  final String ownerId;

  const ShopEntity({
    this.shopId,
    required this.shopName,
    this.address,
    this.contactNumber,
    required this.ownerId,
  });
  @override
  List<Object?> get props => [
    shopId,
    shopName,
    address,
    contactNumber,
    ownerId,
  ];
}
