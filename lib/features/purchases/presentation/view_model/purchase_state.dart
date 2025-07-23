import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';

class PurchaseState extends Equatable {
  final List<PurchaseEntity> purchases;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;

  const PurchaseState({
    required this.purchases,
    required this.isLoading,
    this.errorMessage,
    required this.currentPage,
    required this.hasReachedMax,
  });

  const PurchaseState.initial()
    : purchases = const [],
      isLoading = false,
      errorMessage = null,
      currentPage = 0,
      hasReachedMax = false;

  PurchaseState copyWith({
    List<PurchaseEntity>? purchases,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    bool clearError = false,
  }) {
    return PurchaseState(
      purchases: purchases ?? this.purchases,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    purchases,
    isLoading,
    errorMessage,
    currentPage,
    hasReachedMax,
  ];
}
