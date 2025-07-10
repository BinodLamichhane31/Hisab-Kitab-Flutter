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
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
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
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    final result = await createShopUsecase(
      CreateShopParams(
        shopName: event.shopName,
        address: event.address,
        contactNumber: event.contactNumber,
      ),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (_) {
        emit(state.copyWith(isLoading: false));
        add(LoadShopsEvent());
      },
    );
  }

  void _onNavigateToHomeView(
    NavigateToHomeView event,
    Emitter<ShopState> emit,
  ) {
    Navigator.of(event.context).pushAndRemoveUntil(
      MaterialPageRoute(
        // Instead of providing the ShopViewModel, create and provide
        // the HomeViewModel that the HomeView actually needs.
        builder:
            (context) => BlocProvider(
              create: (context) => serviceLocator<HomeViewModel>(),
              child: const HomeView(),
            ),
      ),
      (route) => false,
    );
  }
}
