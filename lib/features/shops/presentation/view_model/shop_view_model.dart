import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/features/home/presentation/view/home_view.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/create_shop_usecase.dart';
import 'package:hisab_kitab/features/shops/domain/use_case/get_all_shops_usecase.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_event.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_state.dart';

class ShopViewModel extends Bloc<ShopEvent, ShopState> {
  final CreateShopUsecase createShopUsecase;
  final GetAllShopsUsecase getAllShopsUsecase;

  ShopViewModel({
    required this.getAllShopsUsecase,
    required this.createShopUsecase,
  }) : super(const ShopState.initial()) {
    on<CreateShopEvent>(_onCreateShop);
    on<LoadShopsEvent>(_onLoadShops);
    on<NavigateToHomeView>(_onNavigateToHomeView);
    add(LoadShopsEvent());
  }

  Future<void> _onLoadShops(
    LoadShopsEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllShopsUsecase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(isLoading: false, errorMessage: () => failure.message),
        );
      },
      (shops) {
        emit(state.copyWith(shops: shops, isLoading: false));
      },
    );
  }

  Future<void> _onCreateShop(
    CreateShopEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: () => null,
        successMessage: () => null,
        shopCreationSuccess: false,
      ),
    );

    final result = await createShopUsecase(
      CreateShopParams(
        shopName: event.shopName,
        address: event.address,
        contactNumber: event.contactNumber,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(isLoading: false, errorMessage: () => failure.message),
        );
      },
      (_) async {
        final shopsResult = await getAllShopsUsecase();
        shopsResult.fold(
          (failure) {
            emit(
              state.copyWith(
                isLoading: false,
                errorMessage:
                    () =>
                        "Shop created, but failed to refresh list: ${failure.message}",
              ),
            );
          },
          (allShops) {
            emit(
              state.copyWith(
                isLoading: false,
                shops: allShops,
                successMessage: () => "'${event.shopName}' added successfully!",
                shopCreationSuccess: true,
              ),
            );
          },
        );
      },
    );
  }

  void _onNavigateToHomeView(
    NavigateToHomeView event,
    Emitter<ShopState> emit,
  ) {
    Navigator.of(event.context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: serviceLocator<HomeViewModel>(),
              child: const HomeView(),
            ),
      ),
      (route) => false,
    );
  }
}
