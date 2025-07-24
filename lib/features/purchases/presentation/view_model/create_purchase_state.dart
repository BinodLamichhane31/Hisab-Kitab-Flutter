import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';

class PurchaseFormItem extends Equatable {
  final ProductEntity product;
  final int quantity;
  final double unitCost;

  const PurchaseFormItem({
    required this.product,
    required this.quantity,
    required this.unitCost,
  });

  double get total => quantity * unitCost;

  PurchaseFormItem copyWith({int? quantity, double? unitCost}) {
    return PurchaseFormItem(
      product: product,
      quantity: quantity ?? this.quantity,
      unitCost: unitCost ?? this.unitCost,
    );
  }

  @override
  List<Object?> get props => [product.productId, quantity, unitCost];
}

enum CreatePurchaseStatus { initial, loading, success, error }

class CreatePurchaseState extends Equatable {
  final CreatePurchaseStatus status;
  final bool isCashPurchase;
  final SupplierEntity? selectedSupplier;
  final List<PurchaseFormItem> items;
  final double discount;
  final double amountPaid;
  final String notes;
  final String billNumber;
  final DateTime purchaseDate;
  final String? errorMessage;

  const CreatePurchaseState({
    required this.status,
    required this.isCashPurchase,
    this.selectedSupplier,
    required this.items,
    required this.discount,
    required this.amountPaid,
    required this.notes,
    required this.billNumber,
    required this.purchaseDate,
    this.errorMessage,
  });

  factory CreatePurchaseState.initial() {
    return CreatePurchaseState(
      status: CreatePurchaseStatus.initial,
      isCashPurchase: true,
      items: const [],
      discount: 0.0,
      amountPaid: 0.0,
      notes: '',
      billNumber: '',
      purchaseDate: DateTime.now(),
    );
  }

  double get subTotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get grandTotal => subTotal - discount;
  double get amountDue => grandTotal - amountPaid;

  CreatePurchaseState copyWith({
    CreatePurchaseStatus? status,
    bool? isCashPurchase,
    SupplierEntity? selectedSupplier,
    bool clearSupplier = false,
    List<PurchaseFormItem>? items,
    double? discount,
    double? amountPaid,
    String? notes,
    String? billNumber,
    DateTime? purchaseDate,
    String? errorMessage,
    bool clearError = false,
  }) {
    final newState = CreatePurchaseState(
      status: status ?? this.status,
      isCashPurchase: isCashPurchase ?? this.isCashPurchase,
      selectedSupplier:
          clearSupplier ? null : selectedSupplier ?? this.selectedSupplier,
      items: items ?? this.items,
      discount: discount ?? this.discount,
      amountPaid: amountPaid ?? this.amountPaid,
      notes: notes ?? this.notes,
      billNumber: billNumber ?? this.billNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );

    if (newState.isCashPurchase) {
      return newState._copyWithManual(amountPaid: newState.grandTotal);
    }
    return newState;
  }

  CreatePurchaseState _copyWithManual({double? amountPaid}) {
    return CreatePurchaseState(
      status: status,
      isCashPurchase: isCashPurchase,
      selectedSupplier: selectedSupplier,
      items: items,
      discount: discount,
      amountPaid: amountPaid ?? this.amountPaid,
      notes: notes,
      billNumber: billNumber,
      purchaseDate: purchaseDate,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isCashPurchase,
    selectedSupplier,
    items,
    discount,
    amountPaid,
    notes,
    billNumber,
    purchaseDate,
    errorMessage,
  ];
}
