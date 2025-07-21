import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';

class ProductState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const ProductState({
    required this.products,
    required this.isLoading,
    this.errorMessage,
    required this.currentPage,
    required this.hasReachedMax,
  });

  const ProductState.initial()
    : products = const [],
      isLoading = false,
      errorMessage = null,
      currentPage = 0,
      hasReachedMax = false;

  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    products,
    isLoading,
    errorMessage,
    currentPage,
    hasReachedMax,
  ];
}
