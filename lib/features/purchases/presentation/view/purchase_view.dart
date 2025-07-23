import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/get_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_event.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_state.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_view_model.dart';
import 'package:intl/intl.dart';

class PurchasesView extends StatelessWidget {
  const PurchasesView({super.key});

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
              (context) => PurchaseViewModel(
                getPurchasesUsecase: serviceLocator<GetPurchasesUsecase>(),
                shopId: activeShop.shopId!,
              ),
          child: const _PurchasesViewContent(),
        );
      },
    );
  }
}

class _PurchasesViewContent extends StatefulWidget {
  const _PurchasesViewContent();
  @override
  State<_PurchasesViewContent> createState() => _PurchasesViewContentState();
}

class _PurchasesViewContentState extends State<_PurchasesViewContent> {
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

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<PurchaseViewModel>().add(
        LoadPurchasesEvent(
          shopId: context.read<PurchaseViewModel>().shopId,
          search: _searchController.text,
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    context.read<PurchaseViewModel>().add(
      RefreshPurchasesEvent(
        shopId: context.read<PurchaseViewModel>().shopId,
        search: query,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchases')),
      body: Column(
        children: [_buildSearchHeader(), Expanded(child: _buildPurchaseList())],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final result = await Navigator.push<bool>(
          //   context,
          //   MaterialPageRoute(builder: (context) => const CreatePurchaseView()),
          // );
          // if (result == true && mounted) {
          //   _onSearchChanged(_searchController.text);
          // }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigate to Create Purchase Page')),
          );
        },
        backgroundColor: Colors.teal,
        tooltip: 'New Purchase',
        child: const Icon(Icons.receipt_long, size: 28),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search by Bill #',
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

  Widget _buildPurchaseList() {
    return BlocBuilder<PurchaseViewModel, PurchaseState>(
      builder: (context, state) {
        if (state.purchases.isEmpty) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(
            child: Text(
              'No purchases found.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _onSearchChanged(_searchController.text);
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount:
                state.hasReachedMax
                    ? state.purchases.length
                    : state.purchases.length + 1,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemBuilder: (context, index) {
              if (index >= state.purchases.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final purchase = state.purchases[index];
              final statusColor = _getStatusColor(purchase.paymentStatus);
              final isCancelled = purchase.status == PurchaseStatus.CANCELLED;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (isCancelled ? Colors.grey : statusColor)
                        .withOpacity(0.1),
                    child: Icon(
                      isCancelled
                          ? Icons.cancel_outlined
                          : _getStatusIcon(purchase.paymentStatus),
                      color: isCancelled ? Colors.grey : statusColor,
                    ),
                  ),
                  title: Text(
                    purchase.supplier?.name ?? 'Cash Purchase',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Bill: ${purchase.billNumber} • ${DateFormat.yMMMd().format(purchase.purchaseDate)}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. ${purchase.grandTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isCancelled ? "CANCELLED" : purchase.paymentStatus.name,
                        style: TextStyle(
                          color: isCancelled ? Colors.grey : statusColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {},
                ),
              );
            },
          ),
        );
      },
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
