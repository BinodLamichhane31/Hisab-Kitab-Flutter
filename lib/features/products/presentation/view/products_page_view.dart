import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/products/domain/use_case/add_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/get_products_usecase.dart';
import 'package:hisab_kitab/features/products/presentation/view/product_detail_view.dart';
import 'package:hisab_kitab/features/products/presentation/view/product_form_page.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_event.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_state.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_view_model.dart';

class ProductsPageView extends StatelessWidget {
  const ProductsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen:
          (previous, current) =>
              previous.activeShop?.shopId != current.activeShop?.shopId,
      builder: (context, sessionState) {
        final activeShop = sessionState.activeShop;

        if (activeShop == null || activeShop.shopId == null) {
          return const Center(
            child: Text(
              'No shop selected.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return BlocProvider(
          key: ValueKey(
            activeShop.shopId,
          ), // Ensures BLoC is recreated for new shop
          create:
              (context) => ProductViewModel(
                getProductsUsecase: serviceLocator<GetProductsUsecase>(),
                addProductUsecase: serviceLocator<AddProductUsecase>(),
                shopId: activeShop.shopId!,
              ),
          child: const _ProductViewContent(),
        );
      },
    );
  }
}

// Inner stateful widget to handle the search controller
class _ProductViewContent extends StatefulWidget {
  const _ProductViewContent();

  @override
  State<_ProductViewContent> createState() => _ProductViewContentState();
}

class _ProductViewContentState extends State<_ProductViewContent> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final viewModel = context.read<ProductViewModel>();
    viewModel.add(LoadProductsEvent(shopId: viewModel.shopId, search: query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: BlocConsumer<ProductViewModel, ProductState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.products.isEmpty) {
            return const Center(
              child: Text(
                'No products found.\nTap the + button to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final viewModel = context.read<ProductViewModel>();
              viewModel.add(LoadProductsEvent(shopId: viewModel.shopId));
            },
            child: ListView.builder(
              itemCount: state.products.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final product = state.products[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child:
                            product.image != null && product.image!.isNotEmpty
                                ? Image.network(
                                  '${ApiEndpoints.serverAddress}${product.image!}',
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.inventory_2_outlined,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                )
                                : const Icon(
                                  Icons.inventory_2_outlined,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Price: Rs. ${product.sellingPrice.toStringAsFixed(2)}',
                    ),
                    trailing: Text(
                      'Stock: ${product.quantity}',
                      style: TextStyle(
                        color:
                            product.quantity > product.reorderLevel
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ProductDetailView(
                                productId: product.productId!,
                              ),
                        ),
                      );

                      if (result == true) {
                        final viewModel = context.read<ProductViewModel>();
                        viewModel.add(
                          LoadProductsEvent(shopId: viewModel.shopId),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder:
            (context) => FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ProductFormPage(
                          shopId: context.read<ProductViewModel>().shopId,
                        ),
                  ),
                );
                // If result is true, it means a product was added successfully
                if (result == true) {
                  // Refresh the list
                  context.read<ProductViewModel>().add(
                    LoadProductsEvent(
                      shopId: context.read<ProductViewModel>().shopId,
                    ),
                  );
                }
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add, size: 36),
            ),
      ),
    );
  }
}
