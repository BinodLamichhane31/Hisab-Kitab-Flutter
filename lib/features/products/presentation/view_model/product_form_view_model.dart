import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/products/domain/use_case/add_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/update_product_usecase.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_form_event.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_form_state.dart';

class ProductFormViewModel extends Bloc<ProductFormEvent, ProductFormState> {
  final AddProductUsecase addProductUsecase;
  final UpdateProductUsecase updateProductUsecase;

  ProductFormViewModel({
    required this.addProductUsecase,
    required this.updateProductUsecase,
  }) : super(const ProductFormState.initial()) {
    on<SubmitProductFormEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitProductFormEvent event,
    Emitter<ProductFormState> emit,
  ) async {
    emit(state.copyWith(status: ProductFormStatus.loading));

    if (event.productId == null) {
      await _addProduct(event, emit);
    } else {
      await _updateProduct(event, emit);
    }
  }

  Future<void> _addProduct(
    SubmitProductFormEvent event,
    Emitter<ProductFormState> emit,
  ) async {
    final result = await addProductUsecase(
      AddProductParams(
        shopId: event.shopId,
        name: event.name,
        sellingPrice: event.sellingPrice,
        purchasePrice: event.purchasePrice,
        quantity: event.quantity,
        category: event.category,
        description: event.description,
        reorderLevel: event.reorderLevel,
        imageFile: event.imageFile,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductFormStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ProductFormStatus.success)),
    );
  }

  Future<void> _updateProduct(
    SubmitProductFormEvent event,
    Emitter<ProductFormState> emit,
  ) async {
    final productToUpdate = ProductEntity(
      productId: event.productId!,
      shopId: event.shopId,
      name: event.name,
      sellingPrice: event.sellingPrice,
      purchasePrice: event.purchasePrice,
      quantity: event.quantity,
      category: event.category,
      description: event.description,
      reorderLevel: event.reorderLevel,
      image: event.existingImageUrl,
    );

    final result = await updateProductUsecase(
      UpdateProductParams(product: productToUpdate, imageFile: event.imageFile),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductFormStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ProductFormStatus.success)),
    );
  }
}
