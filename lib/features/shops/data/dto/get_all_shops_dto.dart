import 'package:hisab_kitab/features/shops/data/model/shop_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_shops_dto.g.dart';

@JsonSerializable()
class GetAllShopsDto {
  final bool success;
  final int count;
  final List<ShopApiModel> data;

  const GetAllShopsDto({
    required this.success,
    required this.count,
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllShopsDtoToJson(this);

  factory GetAllShopsDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllShopsDtoFromJson(json);
}
