import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/purchases/domain/repository/purchase_repository.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/create_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/create_purchase_event.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/create_purchase_state.dart';

class CreatePurchaseViewModel
    extends Bloc<CreatePurchaseEvent, CreatePurchaseState> {
  final CreatePurchaseUsecase createPurchaseUsecase;
  final String shopId;

  CreatePurchaseViewModel({
    required this.createPurchaseUsecase,
    required this.shopId,
  }) : super(CreatePurchaseState.initial()) {
    on<TogglePurchaseType>(_onTogglePurchaseType);
    on<SupplierSelected>(_onSupplierSelected);
    on<ProductsAdded>(_onProductsAdded);
    on<ItemRemoved>(_onItemRemoved);
    on<ItemQuantityChanged>(_onItemQuantityChanged);
    on<ItemCostChanged>(_onItemCostChanged);
    on<FieldChanged>(_onFieldChanged);
    on<SubmitPurchase>(_onSubmitPurchase);
  }

  void _onTogglePurchaseType(
    TogglePurchaseType event,
    Emitter<CreatePurchaseState> emit,
  ) {
    emit(
      state.copyWith(
        isCashPurchase: event.isCashPurchase,
        clearSupplier: event.isCashPurchase,
        amountPaid: event.isCashPurchase ? state.grandTotal : 0.0,
      ),
    );
  }

  void _onSupplierSelected(
    SupplierSelected event,
    Emitter<CreatePurchaseState> emit,
  ) {
    emit(
      state.copyWith(selectedSupplier: event.supplier, isCashPurchase: false),
    );
  }

  void _onProductsAdded(
    ProductsAdded event,
    Emitter<CreatePurchaseState> emit,
  ) {
    final currentItems = List<PurchaseFormItem>.from(state.items);
    for (var product in event.products) {
      if (!currentItems.any(
        (item) => item.product.productId == product.productId,
      )) {
        currentItems.add(
          PurchaseFormItem(
            product: product,
            quantity: 1,
            unitCost: product.purchasePrice ?? 0.0,
          ),
        );
      }
    }
    emit(state.copyWith(items: currentItems));
  }

  void _onItemRemoved(ItemRemoved event, Emitter<CreatePurchaseState> emit) {
    final updatedItems =
        state.items
            .where((item) => item.product.productId != event.productId)
            .toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onItemQuantityChanged(
    ItemQuantityChanged event,
    Emitter<CreatePurchaseState> emit,
  ) {
    final updatedItems =
        state.items.map((item) {
          if (item.product.productId == event.productId) {
            return item.copyWith(quantity: event.newQuantity);
          }
          return item;
        }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onItemCostChanged(
    ItemCostChanged event,
    Emitter<CreatePurchaseState> emit,
  ) {
    final updatedItems =
        state.items.map((item) {
          if (item.product.productId == event.productId) {
            return item.copyWith(unitCost: event.newCost);
          }
          return item;
        }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onFieldChanged(FieldChanged event, Emitter<CreatePurchaseState> emit) {
    emit(
      state.copyWith(
        discount: event.discount,
        amountPaid: event.amountPaid,
        notes: event.notes,
        billNumber: event.billNumber,
        purchaseDate: event.purchaseDate,
      ),
    );
  }

  Future<void> _onSubmitPurchase(
    SubmitPurchase event,
    Emitter<CreatePurchaseState> emit,
  ) async {
    if (state.items.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please add at least one product to the purchase.',
        ),
      );
      return;
    }
    if (!state.isCashPurchase && state.selectedSupplier == null) {
      emit(
        state.copyWith(
          errorMessage: 'A supplier must be selected for credit purchases.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: CreatePurchaseStatus.loading, clearError: true),
    );

    final params = CreatePurchaseParams(
      shopId: shopId,
      supplierId:
          state.isCashPurchase ? null : state.selectedSupplier?.supplierId,
      items:
          state.items
              .map(
                (item) => (
                  productId: item.product.productId!,
                  quantity: item.quantity,
                  unitCost: item.unitCost,
                ),
              )
              .toList(),
      discount: state.discount,
      amountPaid: state.amountPaid,
      billNumber: state.billNumber.isNotEmpty ? state.billNumber : null,
      notes: state.notes.isNotEmpty ? state.notes : null,
      purchaseDate: state.purchaseDate,
    );

    final result = await createPurchaseUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreatePurchaseStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (purchase) => emit(state.copyWith(status: CreatePurchaseStatus.success)),
    );
  }
}
