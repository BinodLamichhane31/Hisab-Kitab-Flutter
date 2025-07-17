import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/add_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/get_suppliers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_event.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_state.dart';

class SupplierViewModel extends Bloc<SupplierEvent, SupplierState> {
  final GetSuppliersByShopUsecase getSuppliersByShopUsecase;
  final AddSupplierUsecase addSupplierUsecase;
  final String shopId;

  SupplierViewModel({
    required this.getSuppliersByShopUsecase,
    required this.addSupplierUsecase,
    required this.shopId,
  }) : super(const SupplierState.initial()) {
    on<LoadSuppliersEvent>(_onLoadSuppliers);
    on<CreateSupplierEvent>(_onCreateSupplier);

    // Load suppliers for current shop initially
    add(LoadSuppliersEvent(shopId: shopId));
  }

  Future<void> _onLoadSuppliers(
    LoadSuppliersEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getSuppliersByShopUsecase(
      GetSuppliersByShopParams(shopId: event.shopId),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (suppliers) {
        emit(state.copyWith(suppliers: suppliers, isLoading: false));
      },
    );
  }

  Future<void> _onCreateSupplier(
    CreateSupplierEvent event,
    Emitter<SupplierState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    final result = await addSupplierUsecase(
      AddSupplierParams(
        name: event.name,
        phone: event.phone,
        email: event.email,
        address: event.address,
        currentBalance: event.currentBalance,
        shopId: event.shopId,
      ),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (_) {
        emit(state.copyWith(isLoading: false));
        add(LoadSuppliersEvent(shopId: event.shopId));
      },
    );
  }
}
