import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/products/domain/repository/product_repository.dart';

class DeleteProductParams extends Equatable {
  final String productId;

  const DeleteProductParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class DeleteProductUsecase
    implements UseCaseWithParams<bool, DeleteProductParams> {
  final IProductRepository productRepository;

  DeleteProductUsecase({required this.productRepository});

  @override
  Future<Either<Failure, bool>> call(DeleteProductParams params) {
    return productRepository.deleteProduct(params.productId);
  }
}
