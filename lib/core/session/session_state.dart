// In your session_state.dart file

import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class SessionState extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;
  final UserEntity? user;
  final List<ShopEntity> shops;
  final ShopEntity? activeShop;
  final String? message; // For showing snackbars from the UI layer

  const SessionState({
    required this.isAuthenticated,
    required this.isLoading,
    this.user,
    required this.shops,
    this.activeShop,
    this.message,
  });

  factory SessionState.initial() {
    return const SessionState(
      isAuthenticated: false,
      isLoading: false,
      user: null,
      shops: [],
      activeShop: null,
      message: null,
    );
  }

  SessionState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserEntity? user,
    List<ShopEntity>? shops,
    // This is the key part for nullable fields.
    // It allows you to explicitly set the value to null.
    ShopEntity? Function()? activeShop,
    String? Function()? message,
  }) {
    return SessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      shops: shops ?? this.shops,
      // Use the function if provided, otherwise keep the old value.
      activeShop: activeShop != null ? activeShop() : this.activeShop,
      // Same pattern for the message field
      message: message != null ? message() : this.message,
    );
  }

  @override
  List<Object?> get props => [
    isAuthenticated,
    isLoading,
    user,
    shops,
    activeShop,
    message,
  ];
}
