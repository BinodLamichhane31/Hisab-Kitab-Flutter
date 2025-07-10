import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/switch_shop_usecase.dart';

class SessionCubit extends Cubit<SessionState> {
  final SwitchShopUsecase _switchShopUsecase;

  SessionCubit({required SwitchShopUsecase switchShopUsecase})
    : _switchShopUsecase = switchShopUsecase,
      super(SessionState.initial());

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

  Future<void> switchShop(ShopEntity newActiveShop) async {
    if (state.activeShop?.shopId == newActiveShop.shopId) return;

    emit(state.copyWith(isLoading: true));

    final result = await _switchShopUsecase(
      SwitchShopParams(shopId: newActiveShop.shopId!),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false));
      },
      (success) {
        emit(state.copyWith(activeShop: () => newActiveShop, isLoading: false));
      },
    );
  }
}
