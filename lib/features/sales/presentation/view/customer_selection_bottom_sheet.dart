import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/add_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_event.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_state.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_view_model.dart';

class CustomerSelectionBottomSheet extends StatelessWidget {
  const CustomerSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final shopId = context.read<SessionCubit>().state.activeShop?.shopId;
    if (shopId == null) {
      return const Center(child: Text("No active shop found."));
    }

    return BlocProvider(
      create:
          (_) => CustomerViewModel(
            getCustomersByShopUsecase:
                serviceLocator<GetCustomersByShopUsecase>(),
            addCustomerUsecase: serviceLocator<AddCustomerUsecase>(),
            shopId: shopId,
          )..add(LoadCustomersEvent(shopId: shopId)),
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
    final viewModel = context.read<CustomerViewModel>();

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
                  'Select Customer',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged:
                  (query) => viewModel.add(
                    LoadCustomersEvent(shopId: viewModel.shopId, search: query),
                  ),
              decoration: InputDecoration(
                hintText: 'Search by name or phone...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CustomerViewModel, CustomerState>(
              builder: (context, state) {
                if (state.isLoading && state.customers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.errorMessage != null && state.customers.isEmpty) {
                  return Center(child: Text(state.errorMessage!));
                }
                if (state.customers.isEmpty) {
                  return Center(
                    child: Text(
                      state.search?.isNotEmpty ?? false
                          ? 'No customers found for "${state.search}"'
                          : 'No customers to display.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: state.customers.length,
                  separatorBuilder:
                      (_, __) =>
                          const Divider(height: 1, indent: 16, endIndent: 16),
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
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(customer.phone),
                      onTap: () {
                        Navigator.of(context).pop(customer);
                      },
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
