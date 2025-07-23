import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/create_sale_usecase.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/create_sale_event.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/create_sale_state.dart';

class CreateSaleViewModel extends Bloc<CreateSaleEvent, CreateSaleState> {
  final CreateSaleUsecase createSaleUsecase;
  final String shopId;

  CreateSaleViewModel({required this.createSaleUsecase, required this.shopId})
    : super(CreateSaleState.initial()) {
    on<ToggleSaleType>(_onToggleSaleType);
    on<CustomerSelected>(_onCustomerSelected);
    on<ProductsAdded>(_onProductsAdded);
    on<ItemRemoved>(_onItemRemoved);
    on<ItemQuantityChanged>(_onItemQuantityChanged);
    on<ItemPriceChanged>(_onItemPriceChanged);
    on<FieldChanged>(_onFieldChanged);
    on<SubmitSale>(_onSubmitSale);
  }

  void _onToggleSaleType(ToggleSaleType event, Emitter<CreateSaleState> emit) {
    emit(
      state.copyWith(
        isCashSale: event.isCashSale,
        clearCustomer: event.isCashSale, // Clear customer if switching to cash
        amountPaid: event.isCashSale ? state.grandTotal : 0.0,
      ),
    );
  }

  void _onCustomerSelected(
    CustomerSelected event,
    Emitter<CreateSaleState> emit,
  ) {
    emit(state.copyWith(selectedCustomer: event.customer, isCashSale: false));
  }

  void _onProductsAdded(ProductsAdded event, Emitter<CreateSaleState> emit) {
    final currentItems = List<SaleFormItem>.from(state.items);
    for (var product in event.products) {
      if (!currentItems.any(
        (item) => item.product.productId == product.productId,
      )) {
        currentItems.add(
          SaleFormItem(
            product: product,
            quantity: 1,
            priceAtSale: product.sellingPrice,
          ),
        );
      }
    }
    emit(state.copyWith(items: currentItems));
  }

  void _onItemRemoved(ItemRemoved event, Emitter<CreateSaleState> emit) {
    final updatedItems =
        state.items
            .where((item) => item.product.productId != event.productId)
            .toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onItemQuantityChanged(
    ItemQuantityChanged event,
    Emitter<CreateSaleState> emit,
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

  void _onItemPriceChanged(
    ItemPriceChanged event,
    Emitter<CreateSaleState> emit,
  ) {
    final updatedItems =
        state.items.map((item) {
          if (item.product.productId == event.productId) {
            return item.copyWith(priceAtSale: event.newPrice);
          }
          return item;
        }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onFieldChanged(FieldChanged event, Emitter<CreateSaleState> emit) {
    emit(
      state.copyWith(
        discount: event.discount,
        tax: event.tax,
        amountPaid: event.amountPaid,
        notes: event.notes,
        saleDate: event.saleDate,
      ),
    );
  }

  Future<void> _onSubmitSale(
    SubmitSale event,
    Emitter<CreateSaleState> emit,
  ) async {
    // Basic Validation
    if (state.items.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please add at least one product to the sale.',
        ),
      );
      return;
    }
    if (!state.isCashSale && state.selectedCustomer == null) {
      emit(
        state.copyWith(
          errorMessage: 'A customer must be selected for credit sales.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateSaleStatus.loading, clearError: true));

    final params = CreateSaleParams(
      shopId: shopId,
      customerId: state.isCashSale ? null : state.selectedCustomer?.customerId,
      items:
          state.items
              .map(
                (item) => (
                  productId: item.product.productId!,
                  quantity: item.quantity,
                  priceAtSale: item.priceAtSale,
                ),
              )
              .toList(),
      discount: state.discount,
      tax: state.tax,
      amountPaid: state.amountPaid,
      notes: state.notes.isNotEmpty ? state.notes : null,
      saleDate: state.saleDate,
    );

    final result = await createSaleUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreateSaleStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (sale) => emit(state.copyWith(status: CreateSaleStatus.success)),
    );
  }
}
