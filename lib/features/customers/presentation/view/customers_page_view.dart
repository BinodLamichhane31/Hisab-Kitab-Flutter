import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/add_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/customers/presentation/view/customer_detail_page.dart';
import 'package:hisab_kitab/features/customers/presentation/view/widget/customer_form_dialog.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_event.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_state.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_view_model.dart';

class CustomersPageView extends StatelessWidget {
  const CustomersPageView({super.key});

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
              (context) => CustomerViewModel(
                getCustomersByShopUsecase:
                    serviceLocator<GetCustomersByShopUsecase>(),
                addCustomerUsecase: serviceLocator<AddCustomerUsecase>(),
                shopId: activeShop.shopId!,
              ),
          child: Scaffold(
            body: BlocBuilder<CustomerViewModel, CustomerState>(
              builder: (context, state) {
                final customerViewModel = context.read<CustomerViewModel>();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: TextField(
                        key: ValueKey(state.search),
                        onChanged: (query) {
                          customerViewModel.add(
                            LoadCustomersEvent(
                              shopId: customerViewModel.shopId,
                              search: query,
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 14),
                          hintText: 'Search customers by name or phone...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon:
                              (state.search?.isNotEmpty ?? false)
                                  ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      customerViewModel.add(
                                        LoadCustomersEvent(
                                          shopId: customerViewModel.shopId,
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
                          if (state.isLoading && state.customers.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.errorMessage != null &&
                              state.customers.isEmpty) {
                            return Center(child: Text(state.errorMessage!));
                          }

                          if (state.customers.isEmpty) {
                            final hasSearchQuery =
                                state.search?.isNotEmpty ?? false;
                            return Center(
                              child: Text(
                                hasSearchQuery
                                    ? 'No customers found for "${state.search}"'
                                    : 'No customers found.\nTap the + button to add one!',
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
                              final viewModel =
                                  context.read<CustomerViewModel>();
                              viewModel.add(
                                LoadCustomersEvent(
                                  shopId: viewModel.shopId,
                                  search: state.search,
                                ),
                              );
                            },
                            child: ListView.separated(
                              itemCount: state.customers.length,
                              padding: const EdgeInsets.fromLTRB(
                                8.0,
                                0,
                                8.0,
                                8.0,
                              ),
                              separatorBuilder:
                                  (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final customer = state.customers[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange.shade100,
                                    child: Text(
                                      customer.name.isNotEmpty
                                          ? customer.name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    customer.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(customer.phone),
                                  trailing: Text(
                                    'Rs. ${customer.currentBalance.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color:
                                          customer.currentBalance >= 0
                                              ? Colors.green
                                              : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => CustomerDetailPage(
                                              customerId: customer.customerId!,
                                            ),
                                      ),
                                    );

                                    if (result == true) {
                                      final viewModel =
                                          context.read<CustomerViewModel>();
                                      viewModel.add(
                                        LoadCustomersEvent(
                                          shopId: viewModel.shopId,
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
                      showCustomerFormDialog(context);
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
