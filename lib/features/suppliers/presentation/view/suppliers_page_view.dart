import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/add_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/get_suppliers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view/supplier_datail_page.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view/supplier_form_dialog.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_event.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_state.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_view_model.dart';

class SuppliersPageView extends StatelessWidget {
  const SuppliersPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen:
          (previous, current) =>
              previous.activeShop?.shopId != current.activeShop?.shopId,
      builder: (context, sessionState) {
        final activeShop = sessionState.activeShop;

        if (activeShop == null) {
          return const Center(
            child: Text(
              'No shop selected.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return BlocProvider(
          key: ValueKey(activeShop.shopId),
          create:
              (context) => SupplierViewModel(
                getSuppliersByShopUsecase:
                    serviceLocator<GetSuppliersByShopUsecase>(),
                addSupplierUsecase: serviceLocator<AddSupplierUsecase>(),
                shopId: activeShop.shopId!,
              ),
          child: Scaffold(
            body: BlocBuilder<SupplierViewModel, SupplierState>(
              builder: (context, state) {
                final supplierViewModel = context.read<SupplierViewModel>();
                final hasSearchQuery = state.search?.isNotEmpty ?? false;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: TextField(
                        key: ValueKey(state.search),
                        onChanged: (query) {
                          supplierViewModel.add(
                            LoadSuppliersEvent(
                              shopId: supplierViewModel.shopId,
                              search: query,
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 14),
                          hintText: 'Search suppliers by name or phone...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon:
                              hasSearchQuery
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      supplierViewModel.add(
                                        LoadSuppliersEvent(
                                          shopId: supplierViewModel.shopId,
                                          search: '',
                                        ),
                                      );
                                    },
                                  )
                                  : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (state.isLoading && state.suppliers.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.errorMessage != null &&
                              state.suppliers.isEmpty) {
                            return Center(child: Text(state.errorMessage!));
                          }

                          if (state.suppliers.isEmpty) {
                            return Center(
                              child: Text(
                                hasSearchQuery
                                    ? 'No suppliers found for "${state.search}"'
                                    : 'No suppliers found.\nTap the + button to add one!',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () async {
                              // Pass the current search query on refresh
                              supplierViewModel.add(
                                LoadSuppliersEvent(
                                  shopId: supplierViewModel.shopId,
                                  search: state.search,
                                ),
                              );
                            },
                            child: ListView.separated(
                              itemCount: state.suppliers.length,
                              padding: const EdgeInsets.fromLTRB(
                                8.0,
                                0,
                                8.0,
                                8.0,
                              ),
                              separatorBuilder:
                                  (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final supplier = state.suppliers[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange.shade100,
                                    child: Text(
                                      supplier.name.isNotEmpty
                                          ? supplier.name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    supplier.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(supplier.phone),
                                  trailing: Text(
                                    'Rs. ${supplier.currentBalance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color:
                                          supplier.currentBalance >= 0
                                              ? Colors.red
                                              : Colors
                                                  .green, // Suppliers balance is opposite
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => SupplierDetailPage(
                                              supplierId: supplier.supplierId!,
                                            ),
                                      ),
                                    );

                                    if (result == true) {
                                      // Pass the current search query on reload
                                      supplierViewModel.add(
                                        LoadSuppliersEvent(
                                          shopId: supplierViewModel.shopId,
                                          search: state.search,
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: Builder(
              builder:
                  (context) => FloatingActionButton(
                    onPressed: () {
                      showSupplierFormDialog(context);
                    },
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.add, size: 36),
                  ),
            ),
          ),
        );
      },
    );
  }
}
