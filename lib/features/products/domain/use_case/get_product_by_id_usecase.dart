import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/products/domain/repository/product_repository.dart';

class GetProductByIdParams extends Equatable {
  final String productId;

  const GetProductByIdParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class GetProductByIdUsecase
    implements UseCaseWithParams<ProductEntity, GetProductByIdParams> {
  final IProductRepository productRepository;

  GetProductByIdUsecase({required this.productRepository});

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductByIdParams params) {
    return productRepository.getProductById(params.productId);
  }
}
