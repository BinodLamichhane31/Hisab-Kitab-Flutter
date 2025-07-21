import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/products/domain/use_case/delete_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/get_product_by_id_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/update_product_usecase.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_detail_event.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_detail_state.dart';

class ProductDetailViewModel
    extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductByIdUsecase getProductByIdUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;
  final String productId;

  ProductDetailViewModel({
    required this.getProductByIdUsecase,
    required this.updateProductUsecase,
    required this.deleteProductUsecase,
    required this.productId,
  }) : super(const ProductDetailState.initial()) {
    on<LoadProductDetailEvent>(_onLoadProductDetail);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);

    // Immediately trigger the initial data load.
    add(LoadProductDetailEvent(productId: productId));
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final result = await getProductByIdUsecase(
      GetProductByIdParams(productId: event.productId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (product) {
        emit(
          state.copyWith(status: ProductDetailStatus.success, product: product),
        );
      },
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final result = await updateProductUsecase(
      UpdateProductParams(product: event.product, imageFile: event.imageFile),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (updatedProduct) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.success,
            product: updatedProduct,
          ),
        );
        // success message or trigger a snackbar from the UI here
      },
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final result = await deleteProductUsecase(
      DeleteProductParams(productId: event.productId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        if (success) {
          emit(state.copyWith(status: ProductDetailStatus.deleted));
        } else {
          emit(
            state.copyWith(
              status: ProductDetailStatus.error,
              errorMessage: 'Failed to delete product.',
            ),
          );
        }
      },
    );
  }
}
