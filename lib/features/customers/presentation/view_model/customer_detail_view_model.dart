import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/delete_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/update_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_detail_event.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_detail_state.dart';

class CustomerDetailViewModel
    extends Bloc<CustomerDetailEvent, CustomerDetailState> {
  final GetCustomerUsecase _getCustomerByIdUsecase;
  final DeleteCustomerUsecase _deleteCustomerUsecase;
  // final UpdateCustomerUsecase _updateCustomerUsecase; // For future edit functionality

  CustomerDetailViewModel({
    required GetCustomerUsecase getCustomerByIdUsecase,
    required DeleteCustomerUsecase deleteCustomerUsecase,
    // required UpdateCustomerUsecase updateCustomerUsecase,
  }) : _getCustomerByIdUsecase = getCustomerByIdUsecase,
       _deleteCustomerUsecase = deleteCustomerUsecase,
       // _updateCustomerUsecase = updateCustomerUsecase,
       super(const CustomerDetailState.initial()) {
    on<LoadCustomerDetailEvent>(_onLoadCustomerDetail);
    on<DeleteCustomerEvent>(_onDeleteCustomer);
  }

  Future<void> _onLoadCustomerDetail(
    LoadCustomerDetailEvent event,
    Emitter<CustomerDetailState> emit,
  ) async {
    emit(state.copyWith(status: CustomerDetailStatus.loading));
    final result = await _getCustomerByIdUsecase(
      GetCustomerParams(customerId: event.customerId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CustomerDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (customer) => emit(
        state.copyWith(
          status: CustomerDetailStatus.success,
          customer: customer,
        ),
      ),
    );
  }

  Future<void> _onDeleteCustomer(
    DeleteCustomerEvent event,
    Emitter<CustomerDetailState> emit,
  ) async {
    final result = await _deleteCustomerUsecase(
      DeleteCustomerParams(customerId: event.customerId),
    );
    result.fold(
      (failure) {
        // We don't change the main status, just set an error message
        // to be shown in a snackbar by the UI layer.
        emit(
          state.copyWith(
            status: CustomerDetailStatus.success,
            errorMessage: failure.message,
          ),
        );
      },
      // On success, we emit a 'deleted' status to trigger navigation.
      (_) => emit(state.copyWith(status: CustomerDetailStatus.deleted)),
    );
  }
}
