import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class SessionState extends Equatable {
  final bool isAuthenticated;
  final UserEntity? user;
  final String? token;
  final List<ShopEntity> shops;
  final ShopEntity? activeShop;
  final bool isLoading;

  const SessionState({
    this.isAuthenticated = false,
    this.user,
    this.token,
    this.shops = const [],
    this.activeShop,
    this.isLoading = false,
  });

  factory SessionState.initial() {
    return const SessionState();
  }

  SessionState copyWith({
    bool? isAuthenticated,
    UserEntity? user,
    String? token,
    List<ShopEntity>? shops,
    ValueGetter<ShopEntity?>? activeShop,
    bool? isLoading,
  }) {
    return SessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      token: token ?? this.token,
      shops: shops ?? this.shops,
      activeShop: activeShop != null ? activeShop() : this.activeShop,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    isAuthenticated,
    user,
    token,
    shops,
    activeShop,
    isLoading,
  ];
}
