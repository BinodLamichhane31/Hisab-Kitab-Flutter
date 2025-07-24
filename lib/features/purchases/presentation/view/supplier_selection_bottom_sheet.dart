import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/add_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/get_suppliers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_event.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_state.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_view_model.dart';

class SupplierSelectionBottomSheet extends StatelessWidget {
  const SupplierSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final shopId = context.read<SessionCubit>().state.activeShop?.shopId;
    if (shopId == null) {
      return const Center(child: Text("No active shop found."));
    }

    return BlocProvider(
      create:
          (_) => SupplierViewModel(
            getSuppliersByShopUsecase:
                serviceLocator<GetSuppliersByShopUsecase>(),
            addSupplierUsecase: serviceLocator<AddSupplierUsecase>(),
            shopId: shopId,
          )..add(LoadSuppliersEvent(shopId: shopId)),
      child: const _BottomSheetContent(),
    );
  }
}

class _BottomSheetContent extends StatefulWidget {
  const _BottomSheetContent();

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SupplierViewModel>();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
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
                  'Select Supplier',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged:
                  (query) => viewModel.add(
                    LoadSuppliersEvent(shopId: viewModel.shopId, search: query),
                  ),
              decoration: InputDecoration(
                hintText: 'Search by name or phone...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SupplierViewModel, SupplierState>(
              builder: (context, state) {
                if (state.isLoading && state.suppliers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.errorMessage != null && state.suppliers.isEmpty) {
                  return Center(child: Text(state.errorMessage!));
                }
                if (state.suppliers.isEmpty) {
                  return Center(
                    child: Text(
                      state.search?.isNotEmpty ?? false
                          ? 'No suppliers found for "${state.search}"'
                          : 'No suppliers to display.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: state.suppliers.length,
                  separatorBuilder:
                      (_, __) =>
                          const Divider(height: 1, indent: 72, endIndent: 16),
                  itemBuilder: (context, index) {
                    final supplier = state.suppliers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Text(
                          supplier.name.isNotEmpty
                              ? supplier.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        supplier.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(supplier.phone ?? 'No phone number'),
                      onTap: () => Navigator.of(context).pop(supplier),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
