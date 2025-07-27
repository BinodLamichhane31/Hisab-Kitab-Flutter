import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/add_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_event.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class CustomerViewModel extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomersByShopUsecase getCustomersByShopUsecase;
  final AddCustomerUsecase addCustomerUsecase;
  final String shopId;

  CustomerViewModel({
    required this.getCustomersByShopUsecase,
    required this.addCustomerUsecase,
    required this.shopId,
  }) : super(const CustomerState.initial()) {
    on<LoadCustomersEvent>(_onLoadCustomers, transformer: restartable());
    on<CreateCustomerEvent>(_onCreateCustomer);

    add(LoadCustomersEvent(shopId: shopId));
  }

  Future<void> _onLoadCustomers(
    LoadCustomersEvent event,
    Emitter<CustomerState> emit,
  ) async {
    if (state.customers.isEmpty) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }
    final result = await getCustomersByShopUsecase(
      GetCustomersByShopParams(shopId: event.shopId, search: event.search),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (customers) {
        emit(state.copyWith(customers: customers, isLoading: false));
      },
    );
  }

  Future<void> _onCreateCustomer(
    CreateCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    final result = await addCustomerUsecase(
      AddCustomerParams(
        name: event.name,
        phone: event.phone,
        email: event.email,
        address: event.address,
        currentBalance: event.currentBalance,
        totalSpent: event.totalSpent,
        shopId: event.shopId,
      ),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (_) {
        add(LoadCustomersEvent(shopId: event.shopId));
      },
    );
  }
}
