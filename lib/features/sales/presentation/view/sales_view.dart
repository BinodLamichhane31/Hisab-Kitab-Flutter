import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_view_model.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/get_sales_usecase.dart';
import 'package:hisab_kitab/features/sales/presentation/view/sale_detail_view.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_event.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_state.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_view_model.dart';
import 'package:intl/intl.dart';

class SalesView extends StatelessWidget {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen:
          (previous, current) =>
              previous.activeShop?.shopId != current.activeShop?.shopId,
      builder: (context, sessionState) {
        final activeShop = sessionState.activeShop;

        if (activeShop == null || activeShop.shopId == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'No shop selected.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          );
        }

        return BlocProvider(
          key: ValueKey(activeShop.shopId),
          create:
              (context) => SaleViewModel(
                getSalesUsecase: serviceLocator<GetSalesUsecase>(),
                shopId: activeShop.shopId!,
              ),
          child: const _SalesViewContent(),
        );
      },
    );
  }
}

class _SalesViewContent extends StatefulWidget {
  const _SalesViewContent();

  @override
  State<_SalesViewContent> createState() => _SalesViewContentState();
}

class _SalesViewContentState extends State<_SalesViewContent> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) {
      final viewModel = context.read<SaleViewModel>();
      viewModel.add(
        LoadSalesEvent(
          shopId: viewModel.shopId,
          search: _searchController.text,
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    final viewModel = context.read<SaleViewModel>();
    viewModel.add(RefreshSalesEvent(shopId: viewModel.shopId, search: query));
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search by Invoice #',
          prefixIcon: const Icon(Icons.search, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(
            child: BlocConsumer<SaleViewModel, SaleState>(
              listener: (context, state) {
                if (state.errorMessage != null && state.sales.isNotEmpty) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.errorMessage!)),
                    );
                }
              },
              builder: (context, state) {
                if (state.sales.isEmpty) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const Center(
                    child: Text(
                      'No sales found.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    final viewModel = context.read<SaleViewModel>();
                    viewModel.add(
                      RefreshSalesEvent(
                        shopId: viewModel.shopId,
                        search: _searchController.text,
                      ),
                    );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        state.hasReachedMax
                            ? state.sales.length
                            : state.sales.length + 1,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemBuilder: (context, index) {
                      if (index >= state.sales.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final sale = state.sales[index];
                      final statusColor = _getStatusColor(sale.paymentStatus);

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: statusColor.withOpacity(0.1),
                            child: Icon(
                              sale.status.name == "COMPLETED"
                                  ? _getStatusIcon(sale.paymentStatus)
                                  : Icons.cancel_outlined,
                              color:
                                  sale.status.name == "COMPLETED"
                                      ? statusColor
                                      : Colors.grey,
                            ),
                          ),
                          title: Text(
                            sale.customer?.name ?? 'Walk-in Customer',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'INV: ${sale.invoiceNumber} • ${DateFormat.yMMMd().format(sale.saleDate)}',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rs. ${sale.grandTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                sale.status.name == "COMPLETED"
                                    ? sale.paymentStatus.name
                                    : "CANCELLED",
                                style: TextStyle(
                                  color:
                                      sale.status.name == "COMPLETED"
                                          ? statusColor
                                          : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => SaleDetailView(saleId: sale.saleId!),
                              ),
                            );

                            if (result == true) {
                              final viewModel = context.read<SaleViewModel>();
                              viewModel.add(
                                LoadSalesEvent(shopId: viewModel.shopId),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        tooltip: 'New Sale',
        child: const Icon(Icons.add_shopping_cart, size: 28),
      ),
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.PAID:
        return Colors.green;
      case PaymentStatus.PARTIAL:
        return Colors.orange;
      case PaymentStatus.UNPAID:
        return Colors.red;
      case PaymentStatus.CANCELLED:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.PAID:
        return Icons.check_circle;
      case PaymentStatus.PARTIAL:
        return Icons.hourglass_bottom;
      case PaymentStatus.UNPAID:
        return Icons.error;
      case PaymentStatus.CANCELLED:
        return Icons.cancel_schedule_send;
    }
  }
}
