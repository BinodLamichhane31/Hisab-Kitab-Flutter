import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/products/domain/use_case/add_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/get_products_usecase.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_event.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_state.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_view_model.dart';

class ProductSelectionBottomSheet extends StatelessWidget {
  final Set<String> alreadyAddedProductIds;

  const ProductSelectionBottomSheet({
    super.key,
    required this.alreadyAddedProductIds,
  });

  @override
  Widget build(BuildContext context) {
    final shopId = context.read<SessionCubit>().state.activeShop?.shopId;
    if (shopId == null) {
      return const Center(child: Text("No active shop found."));
    }

    return BlocProvider(
      create:
          (_) => ProductViewModel(
            getProductsUsecase: serviceLocator<GetProductsUsecase>(),
            addProductUsecase: serviceLocator<AddProductUsecase>(),
            shopId: shopId,
          ),
      child: _BottomSheetContent(
        alreadyAddedProductIds: alreadyAddedProductIds,
      ),
    );
  }
}

class _BottomSheetContent extends StatefulWidget {
  final Set<String> alreadyAddedProductIds;
  const _BottomSheetContent({required this.alreadyAddedProductIds});

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedProductIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onProductTapped(ProductEntity product) {
    if (widget.alreadyAddedProductIds.contains(product.productId)) return;

    setState(() {
      if (_selectedProductIds.contains(product.productId)) {
        _selectedProductIds.remove(product.productId);
      } else {
        _selectedProductIds.add(product.productId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProductViewModel>();
    final productState = context.watch<ProductViewModel>().state;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Select Products',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged:
                  (query) => viewModel.add(
                    RefreshProductsEvent(
                      shopId: viewModel.shopId,
                      search: query,
                    ),
                  ),
              decoration: InputDecoration(
                hintText: 'Search products by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductViewModel, ProductState>(
              builder: (context, state) {
                if (state.isLoading && state.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.products.isEmpty) {
                  return Center(
                    child: Text(
                      'No products found for "${_searchController.text}"',
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    final isAlreadyInSale = widget.alreadyAddedProductIds
                        .contains(product.productId);
                    final isSelectedInSheet = _selectedProductIds.contains(
                      product.productId,
                    );

                    return ListTile(
                      tileColor:
                          isSelectedInSheet
                              ? Colors.orange.withOpacity(0.1)
                              : null,
                      onTap: () => _onProductTapped(product),
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.orange,
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text('In Stock: ${product.quantity}'),
                      trailing: Checkbox(
                        value: isSelectedInSheet || isAlreadyInSale,
                        onChanged:
                            isAlreadyInSale
                                ? null
                                : (bool? value) => _onProductTapped(product),
                        activeColor: Colors.orange,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: Text('Add ${_selectedProductIds.length} Products'),
                onPressed:
                    _selectedProductIds.isEmpty
                        ? null
                        : () {
                          final selectedProducts =
                              productState.products
                                  .where(
                                    (p) => _selectedProductIds.contains(
                                      p.productId,
                                    ),
                                  )
                                  .toList();
                          Navigator.of(context).pop(selectedProducts);
                        },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
