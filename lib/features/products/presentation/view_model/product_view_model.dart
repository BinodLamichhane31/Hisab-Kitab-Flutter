import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/products/domain/use_case/add_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/get_products_usecase.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_event.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_state.dart'; // Make sure you import this

class ProductViewModel extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;
  final AddProductUsecase addProductUsecase;
  final String shopId;

  static const int _productLimit = 20;

  ProductViewModel({
    required this.getProductsUsecase,
    required this.addProductUsecase,
    required this.shopId,
  }) : super(const ProductState.initial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
    on<AddNewProductEvent>(_onAddNewProduct);
    on<UpdateProductInListEvent>(_onUpdateProductInList);
    on<DeleteProductFromListEvent>(_onDeleteProductFromList);

    add(LoadProductsEvent(shopId: shopId));
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoading) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));
    final nextPage = state.currentPage + 1;

    final result = await getProductsUsecase(
      GetProductsParams(
        shopId: event.shopId,
        page: nextPage,
        limit: _productLimit,
        search: event.search,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (newProducts) {
        emit(
          state.copyWith(
            products: List.of(state.products)..addAll(newProducts),
            isLoading: false,
            currentPage: nextPage,
            hasReachedMax: newProducts.length < _productLimit,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.initial());
    add(LoadProductsEvent(shopId: event.shopId, search: event.search));
  }

  Future<void> _onAddNewProduct(
    AddNewProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await addProductUsecase(
      AddProductParams(
        name: event.name,
        sellingPrice: event.sellingPrice,
        purchasePrice: event.purchasePrice,
        quantity: event.quantity,
        category: event.category,
        description: event.description,
        reorderLevel: event.reorderLevel,
        shopId: event.shopId,
        imageFile: event.imageFile,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (newProduct) {
        final updatedProducts = [newProduct, ...state.products];
        emit(state.copyWith(products: updatedProducts, isLoading: false));
      },
    );
  }

  void _onUpdateProductInList(
    UpdateProductInListEvent event,
    Emitter<ProductState> emit,
  ) {
    final updatedProducts =
        state.products.map((product) {
          return product.productId == event.updatedProduct.productId
              ? event.updatedProduct
              : product;
        }).toList();

    emit(state.copyWith(products: updatedProducts));
  }

  void _onDeleteProductFromList(
    DeleteProductFromListEvent event,
    Emitter<ProductState> emit,
  ) {
    final updatedProducts =
        state.products
            .where((product) => product.productId != event.productId)
            .toList();

    emit(state.copyWith(products: updatedProducts));
  }
}
