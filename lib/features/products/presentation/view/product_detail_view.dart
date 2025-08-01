import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/products/domain/use_case/delete_product_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/get_product_by_id_usecase.dart';
import 'package:hisab_kitab/features/products/domain/use_case/update_product_usecase.dart';
import 'package:hisab_kitab/features/products/presentation/view/product_form_page.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_detail_event.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_detail_state.dart';
import 'package:hisab_kitab/features/products/presentation/view_model/product_detail_view_model.dart';

class ProductDetailView extends StatelessWidget {
  final String productId;

  const ProductDetailView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ProductDetailViewModel(
            getProductByIdUsecase: serviceLocator<GetProductByIdUsecase>(),
            updateProductUsecase: serviceLocator<UpdateProductUsecase>(),
            deleteProductUsecase: serviceLocator<DeleteProductUsecase>(),
            productId: productId,
          ),
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailViewModel, ProductDetailState>(
      listener: (context, state) {
        if (state.status == ProductDetailStatus.deleted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Product deleted successfully.'),
                backgroundColor: Colors.green,
              ),
            );
          Navigator.of(context).pop(true);
        } else if (state.status == ProductDetailStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      // Builder handles building the UI based on the state
      builder: (context, state) {
        final product = state.product;

        return Scaffold(
          appBar: AppBar(
            title: Text(state.product?.name ?? 'Product Details'),
            actions: [
              // Show actions only when the product has loaded successfully
              if (state.status == ProductDetailStatus.success &&
                  product != null)
                // Edit Button
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit Product',
                  onPressed: () async {
                    final result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProductFormPage(
                              shopId: product.shopId,
                              productToEdit: product,
                            ),
                      ),
                    );
                    if (result == true) {
                      context.read<ProductDetailViewModel>().add(
                        LoadProductDetailEvent(productId: product.productId!),
                      );
                    }
                  },
                ),
              if (state.status == ProductDetailStatus.success &&
                  product != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Delete Product',
                  onPressed: () => _showDeleteConfirmationDialog(context),
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProductDetailState state) {
    switch (state.status) {
      case ProductDetailStatus.loading:
      case ProductDetailStatus.initial:
        return const Center(child: CircularProgressIndicator());
      case ProductDetailStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.errorMessage ?? 'An unknown error occurred.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final viewModel = context.read<ProductDetailViewModel>();
                  viewModel.add(
                    LoadProductDetailEvent(productId: viewModel.productId),
                  );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case ProductDetailStatus.success:
        if (state.product == null) {
          return const Center(child: Text('Product not found.'));
        }
        return _ProductDetailsContent(product: state.product!);
      case ProductDetailStatus.deleted:
        return const Center(child: Text('Product has been deleted.'));
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final viewModel = context.read<ProductDetailViewModel>();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
            'Are you sure you want to delete this product? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                viewModel.add(
                  DeleteProductEvent(productId: viewModel.productId),
                );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  final ProductEntity product;

  const _ProductDetailsContent({required this.product});

  @override
  Widget build(BuildContext context) {
    String? fullImageUrl;
    if (product.image != null && product.image!.isNotEmpty) {
      fullImageUrl = '${ApiEndpoints.baseUrl}${product.image!}';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (fullImageUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  fullImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            product.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (product.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                product.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
            ),
          const SizedBox(height: 16),
          const Divider(),
          _buildDetailRow(
            context,
            icon: Icons.category_outlined,
            title: 'Category',
            value: product.category,
          ),
          _buildDetailRow(
            context,
            icon: Icons.sell_outlined,
            title: 'Selling Price',
            value: 'Rs. ${product.sellingPrice.toStringAsFixed(2)}',
          ),
          _buildDetailRow(
            context,
            icon: Icons.shopping_cart_outlined,
            title: 'Purchase Price',
            value: 'Rs. ${product.purchasePrice.toStringAsFixed(2)}',
          ),
          _buildDetailRow(
            context,
            icon: Icons.inventory_outlined,
            title: 'Quantity in Stock',
            value: '${product.quantity}',
            valueColor:
                product.quantity > product.reorderLevel
                    ? Colors.green.shade700
                    : Colors.red.shade700,
          ),
          _buildDetailRow(
            context,
            icon: Icons.warning_amber_rounded,
            title: 'Re-order Level',
            value: '${product.reorderLevel}',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade800),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
