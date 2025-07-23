import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

class SaleFormItem extends Equatable {
  final ProductEntity product;
  final int quantity;
  final double priceAtSale;

  const SaleFormItem({
    required this.product,
    required this.quantity,
    required this.priceAtSale,
  });

  double get total => quantity * priceAtSale;

  SaleFormItem copyWith({int? quantity, double? priceAtSale}) {
    return SaleFormItem(
      product: product,
      quantity: quantity ?? this.quantity,
      priceAtSale: priceAtSale ?? this.priceAtSale,
    );
  }

  @override
  List<Object?> get props => [product.productId, quantity, priceAtSale];
}

enum CreateSaleStatus { initial, loading, success, error }

class CreateSaleState extends Equatable {
  final CreateSaleStatus status;
  final bool isCashSale;
  final CustomerEntity? selectedCustomer;
  final List<SaleFormItem> items;
  final double discount;
  final double tax;
  final double amountPaid;
  final String notes;
  final DateTime saleDate;
  final String? errorMessage;

  const CreateSaleState({
    required this.status,
    required this.isCashSale,
    this.selectedCustomer,
    required this.items,
    required this.discount,
    required this.tax,
    required this.amountPaid,
    required this.notes,
    required this.saleDate,
    this.errorMessage,
  });

  factory CreateSaleState.initial() {
    return CreateSaleState(
      status: CreateSaleStatus.initial,
      isCashSale: true,
      items: const [],
      discount: 0.0,
      tax: 0.0,
      amountPaid: 0.0,
      notes: '',
      saleDate: DateTime.now(),
    );
  }

  double get subTotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get grandTotal => subTotal - discount + tax;
  double get amountDue => grandTotal - amountPaid;

  CreateSaleState copyWith({
    CreateSaleStatus? status,
    bool? isCashSale,
    CustomerEntity? selectedCustomer,
    bool clearCustomer = false,
    List<SaleFormItem>? items,
    double? discount,
    double? tax,
    double? amountPaid,
    String? notes,
    DateTime? saleDate,
    String? errorMessage,
    bool clearError = false,
  }) {
    final newState = CreateSaleState(
      status: status ?? this.status,
      isCashSale: isCashSale ?? this.isCashSale,
      selectedCustomer:
          clearCustomer ? null : selectedCustomer ?? this.selectedCustomer,
      items: items ?? this.items,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      amountPaid: amountPaid ?? this.amountPaid,
      notes: notes ?? this.notes,
      saleDate: saleDate ?? this.saleDate,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );

    if (newState.isCashSale) {
      return newState._copyWithManual(amountPaid: newState.grandTotal);
    }
    return newState;
  }

  CreateSaleState _copyWithManual({double? amountPaid}) {
    return CreateSaleState(
      status: status,
      isCashSale: isCashSale,
      selectedCustomer: selectedCustomer,
      items: items,
      discount: discount,
      tax: tax,
      amountPaid: amountPaid ?? this.amountPaid,
      notes: notes,
      saleDate: saleDate,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isCashSale,
    selectedCustomer,
    items,
    discount,
    tax,
    amountPaid,
    notes,
    saleDate,
    errorMessage,
  ];
}
