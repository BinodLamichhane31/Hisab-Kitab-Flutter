import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionState.initial());

  void onLoginSuccess({
    required UserEntity user,
    required List<ShopEntity> shops,
    required ShopEntity? activeShop,
  }) {
    emit(
      state.copyWith(
        isAuthenticated: true,
        user: user,
        shops: shops,
        activeShop: () => activeShop,
      ),
    );
  }

  void onShopAdded(ShopEntity newShop) {
    final updatedShops = List<ShopEntity>.from(state.shops)..add(newShop);
    emit(
      state.copyWith(
        shops: updatedShops,
        // If it's the first shop, make it active
        activeShop: () => state.activeShop ?? newShop,
      ),
    );
  }

  void onLogout() {
    emit(SessionState.initial());
  }
}
