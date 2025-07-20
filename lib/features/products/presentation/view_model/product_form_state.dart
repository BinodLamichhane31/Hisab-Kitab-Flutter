import 'package:equatable/equatable.dart';

enum ProductFormStatus { initial, loading, success, error }

class ProductFormState extends Equatable {
  final ProductFormStatus status;
  final String? errorMessage;

  const ProductFormState({required this.status, this.errorMessage});

  const ProductFormState.initial()
    : status = ProductFormStatus.initial,
      errorMessage = null;

  ProductFormState copyWith({ProductFormStatus? status, String? errorMessage}) {
    return ProductFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
