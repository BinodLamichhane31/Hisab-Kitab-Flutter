import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/delete_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/get_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/update_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_detail_event.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_detail_state.dart';

class SupplierDetailViewModel
    extends Bloc<SupplierDetailEvent, SupplierDetailState> {
  final GetSupplierUsecase _getSupplierByIdUsecase;
  final DeleteSupplierUsecase _deleteSupplierUsecase;
  final UpdateSupplierUsecase _updateSupplierUsecase;

  SupplierDetailViewModel({
    required GetSupplierUsecase getSupplierByIdUsecase,
    required DeleteSupplierUsecase deleteSupplierUsecase,
    required UpdateSupplierUsecase updateSupplierUsecase,
  }) : _getSupplierByIdUsecase = getSupplierByIdUsecase,
       _deleteSupplierUsecase = deleteSupplierUsecase,
       _updateSupplierUsecase = updateSupplierUsecase,
       super(const SupplierDetailState.initial()) {
    on<LoadSupplierDetailEvent>(_onLoadSupplierDetail);
    on<UpdateSupplierDetailEvent>(_onUpdateSupplier);
    on<DeleteSupplierEvent>(_onDeleteSupplier);
  }

  Future<void> _onLoadSupplierDetail(
    LoadSupplierDetailEvent event,
    Emitter<SupplierDetailState> emit,
  ) async {
    emit(state.copyWith(status: SupplierDetailStatus.loading));
    final result = await _getSupplierByIdUsecase(
      GetSupplierParams(supplierId: event.supplierId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SupplierDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (supplier) => emit(
        state.copyWith(
          status: SupplierDetailStatus.success,
          supplier: supplier,
        ),
      ),
    );
  }

  Future<void> _onUpdateSupplier(
    UpdateSupplierDetailEvent event,
    Emitter<SupplierDetailState> emit,
  ) async {
    final result = await _updateSupplierUsecase(
      UpdateSupplierParams(supplier: event.supplier),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message, clearError: false));
      },
      (updatedSupplier) {
        emit(
          state.copyWith(
            status: SupplierDetailStatus.success,
            supplier: updatedSupplier,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteSupplier(
    DeleteSupplierEvent event,
    Emitter<SupplierDetailState> emit,
  ) async {
    final result = await _deleteSupplierUsecase(
      DeleteSupplierParams(supplierId: event.supplierId),
    );
    result.fold((failure) {
      emit(
        state.copyWith(
          status: SupplierDetailStatus.success,
          errorMessage: failure.message,
        ),
      );
    }, (_) => emit(state.copyWith(status: SupplierDetailStatus.deleted)));
  }
}
