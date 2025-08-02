import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/network/socket_service.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/switch_shop_usecase.dart';

class SessionCubit extends Cubit<SessionState> {
  final SwitchShopUsecase _switchShopUsecase;
  final SocketService _socketService;

  SessionCubit({
    required SwitchShopUsecase switchShopUsecase,
    required SocketService socketService,
  }) : _switchShopUsecase = switchShopUsecase,
       _socketService = socketService,
       super(SessionState.initial());

  void onLoginSuccess({
    required UserEntity user,
    required String token,
    required List<ShopEntity> shops,
    required ShopEntity? activeShop,
  }) {
    _socketService.connect(token, user.userId!);

    emit(
      state.copyWith(
        isAuthenticated: true,
        user: user,
        token: token,
        shops: shops,
        activeShop: () => activeShop,
      ),
    );
  }

  void onShopsUpdated(List<ShopEntity> updatedShops) {
    final newActiveShop =
        state.activeShop ??
        (updatedShops.isNotEmpty ? updatedShops.last : null);
    emit(state.copyWith(shops: updatedShops, activeShop: () => newActiveShop));
  }

  void onShopAdded(ShopEntity newShop) {
    final updatedShops = List<ShopEntity>.from(state.shops)..add(newShop);
    emit(
      state.copyWith(
        shops: updatedShops,
        activeShop: () => state.activeShop ?? newShop,
      ),
    );
  }

  void onLogout() {
    _socketService.disconnect();
    emit(SessionState.initial());
  }

  Future<void> switchShop(
    ShopEntity newActiveShop,
    BuildContext context,
    String shopName,
  ) async {
    if (state.activeShop?.shopId == newActiveShop.shopId) return;

    emit(state.copyWith(isLoading: true));

    final result = await _switchShopUsecase(
      SwitchShopParams(shopId: newActiveShop.shopId!),
    );

    result.fold(
      (failure) {
        // Check if context is still mounted before showing snackbar
        if (context.mounted) {
          showMySnackBar(context: context, message: failure.message);
        }
        emit(state.copyWith(isLoading: false));
      },
      (success) {
        // Check if context is still mounted before showing snackbar
        if (context.mounted) {
          showMySnackBar(
            context: context,
            message: "Active shop set to $shopName.",
          );
        }
        // Update the active shop in the state
        emit(state.copyWith(activeShop: () => newActiveShop, isLoading: false));
      },
    );
  }
}
