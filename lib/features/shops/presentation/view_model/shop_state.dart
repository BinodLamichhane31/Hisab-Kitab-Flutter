import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class ShopState extends Equatable {
  final List<ShopEntity> shops;
  final bool isLoading;
  final String? errorMessage;

  const ShopState({
    required this.shops,
    required this.isLoading,
    this.errorMessage,
  });

  const ShopState.initial()
    : shops = const [],
      isLoading = false,
      errorMessage = null;

  ShopState copyWith({
    List<ShopEntity>? shops,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ShopState(
      shops: shops ?? this.shops,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [shops, isLoading, errorMessage];
}
