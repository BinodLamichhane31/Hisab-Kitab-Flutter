import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hisab_kitab/app/use_case/usecase.dart';
import 'package:hisab_kitab/core/error/failure.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/products/domain/repository/product_repository.dart';

class GetProductsParams extends Equatable {
  final String shopId;
  final int? page;
  final int? limit;
  final String? search;

  const GetProductsParams({
    required this.shopId,
    this.page,
    this.limit,
    this.search,
  });

  @override
  List<Object?> get props => [shopId, page, limit, search];
}

class GetProductsUsecase
    implements UseCaseWithParams<List<ProductEntity>, GetProductsParams> {
  final IProductRepository productRepository;

  GetProductsUsecase({required this.productRepository});

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
    GetProductsParams params,
  ) async {
    return await productRepository.getProductsByShop(
      params.shopId,
      page: params.page,
      limit: params.limit,
      search: params.search,
    );
  }
}
