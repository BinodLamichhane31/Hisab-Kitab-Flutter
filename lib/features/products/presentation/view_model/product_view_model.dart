import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/products/domain/use_case/add_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/get_products_usecase.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_event.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_state.dart';

class ProductViewModel extends Bloc<ProductEvent, ProductState> {
  final GetProductsUsecase getProductsUsecase;
  final AddProductUsecase addProductUsecase;
  final String shopId;

  ProductViewModel({
    required this.getProductsUsecase,
    required this.addProductUsecase,
    required this.shopId,
  }) : super(const ProductState.initial()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<AddNewProductEvent>(_onAddNewProduct);

    add(LoadProductsEvent(shopId: shopId));
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getProductsUsecase(
      GetProductsParams(
        shopId: event.shopId,
        page: event.page,
        limit: event.limit,
        search: event.search,
      ),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (products) {
        emit(state.copyWith(products: products, isLoading: false));
      },
    );
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
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (_) {
        emit(state.copyWith(isLoading: false));
        add(LoadProductsEvent(shopId: event.shopId));
      },
    );
  }
}
