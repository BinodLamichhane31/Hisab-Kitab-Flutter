import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

enum ProductDetailStatus { initial, loading, success, error, deleted }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final ProductEntity? product;
  final String? errorMessage;

  const ProductDetailState({
    required this.status,
    this.product,
    this.errorMessage,
  });

  const ProductDetailState.initial()
    : status = ProductDetailStatus.initial,
      product = null,
      errorMessage = null;

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductEntity? product,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, product, errorMessage];
}
