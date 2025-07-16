import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class ShopState extends Equatable {
  final List<ShopEntity> shops;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool shopCreationSuccess;

  const ShopState({
    required this.shops,
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
    this.shopCreationSuccess = false,
  });

  const ShopState.initial()
    : shops = const [],
      isLoading = false,
      errorMessage = null,
      successMessage = null,
      shopCreationSuccess = false;

  ShopState copyWith({
    List<ShopEntity>? shops,
    bool? isLoading,
    ValueGetter<String?>? errorMessage,
    ValueGetter<String?>? successMessage,
    bool? shopCreationSuccess,
  }) {
    return ShopState(
      shops: shops ?? this.shops,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage:
          successMessage != null ? successMessage() : this.successMessage,
      shopCreationSuccess: shopCreationSuccess ?? this.shopCreationSuccess,
    );
  }

  @override
  List<Object?> get props => [
    shops,
    isLoading,
    errorMessage,
    successMessage,
    shopCreationSuccess,
  ];
}
