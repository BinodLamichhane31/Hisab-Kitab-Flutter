import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';

class SaleState extends Equatable {
  final List<SaleEntity> sales;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const SaleState({
    required this.sales,
    required this.isLoading,
    this.errorMessage,
    required this.currentPage,
    required this.hasReachedMax,
  });

  const SaleState.initial()
    : sales = const [],
      isLoading = false,
      errorMessage = null,
      currentPage = 0,
      hasReachedMax = false;

  SaleState copyWith({
    List<SaleEntity>? sales,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    bool clearError = false, // Helper to easily clear error messages
  }) {
    return SaleState(
      sales: sales ?? this.sales,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    sales,
    isLoading,
    errorMessage,
    currentPage,
    hasReachedMax,
  ];
}
