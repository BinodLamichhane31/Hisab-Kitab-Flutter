import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

part 'shop_api_model.g.dart';

@JsonSerializable()
class ShopApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? shopId;

  @JsonKey(name: 'name')
  final String shopName;

  final String? address;
  final String? contactNumber;
  final ShopOwnerApiModel owner;

  const ShopApiModel({
    this.shopId,
    required this.shopName,
    this.address,
    this.contactNumber,
    required this.owner,
  });

  factory ShopApiModel.fromJson(Map<String, dynamic> json) =>
      _$ShopApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopApiModelToJson(this);

  ShopEntity toEntity() {
    return ShopEntity(
      shopId: shopId,
      shopName: shopName,
      address: address,
      contactNumber: contactNumber,
      ownerId: owner.ownerId,
    );
  }

  factory ShopApiModel.fromEntity(ShopEntity entity) {
    return ShopApiModel(
      shopId: entity.shopId,
      shopName: entity.shopName,
      address: entity.address,
      contactNumber: entity.contactNumber,
      owner: ShopOwnerApiModel(
        ownerId: entity.ownerId,
        fname: '',
        lname: '',
        email: '',
      ),
    );
  }
  // =============================================================

  @override
  List<Object?> get props => [shopId, shopName, address, contactNumber, owner];
}

@JsonSerializable()
class ShopOwnerApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String ownerId;
  final String fname;
  final String lname;
  final String email;

  const ShopOwnerApiModel({
    required this.ownerId,
    required this.fname,
    required this.lname,
    required this.email,
  });

  factory ShopOwnerApiModel.fromJson(Map<String, dynamic> json) =>
      _$ShopOwnerApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopOwnerApiModelToJson(this);

  @override
  List<Object?> get props => [ownerId, fname, lname, email];
}
