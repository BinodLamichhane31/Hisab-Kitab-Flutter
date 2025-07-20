import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

class ProductState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? errorMessage;

  const ProductState({
    required this.products,
    required this.isLoading,
    this.errorMessage,
  });

  const ProductState.initial()
    : products = const [],
      isLoading = false,
      errorMessage = null;

  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, errorMessage];
}
