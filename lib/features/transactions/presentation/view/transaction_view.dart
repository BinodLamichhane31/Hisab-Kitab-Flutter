import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_entity.dart';
import 'package:hisab_kitab/features/transactions/domain/entity/transaction_enums.dart';
import 'package:hisab_kitab/features/transactions/domain/use_case/get_transactions_usecase.dart';
import 'package:hisab_kitab/features/transactions/presentation/view_model/transaction_event.dart';
import 'package:hisab_kitab/features/transactions/presentation/view_model/transaction_state.dart';
import 'package:hisab_kitab/features/transactions/presentation/view_model/transaction_view_model.dart';
import 'package:intl/intl.dart';

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
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
              (context) => TransactionViewModel(
                getTransactionsUsecase:
                    serviceLocator<GetTransactionsUsecase>(),
                shopId: activeShop.shopId!,
              ),
          child: const _TransactionsViewContent(),
        );
      },
    );
  }
}

class _TransactionsViewContent extends StatefulWidget {
  const _TransactionsViewContent();
  @override
  State<_TransactionsViewContent> createState() =>
      _TransactionsViewContentState();
}

class _TransactionsViewContentState extends State<_TransactionsViewContent> {
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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        context.read<TransactionViewModel>().state.isLoading)
      return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      final viewModel = context.read<TransactionViewModel>();
      viewModel.add(
        LoadTransactionsEvent(
          shopId: viewModel.shopId,
          search: viewModel.state.search,
          type: viewModel.state.type,
          // Pass other filters if you add them
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    context.read<TransactionViewModel>().add(
      RefreshTransactionsEvent(
        shopId: context.read<TransactionViewModel>().shopId,
        search: query,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter bottom sheet
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter functionality to be added.'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(child: _buildTransactionList()),
        ],
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
          hintText: 'Search by description...',
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

  Widget _buildTransactionList() {
    return BlocBuilder<TransactionViewModel, TransactionState>(
      builder: (context, state) {
        if (state.transactions.isEmpty) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }
          return const Center(
            child: Text(
              'No transactions found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<TransactionViewModel>().add(
              RefreshTransactionsEvent(
                shopId: context.read<TransactionViewModel>().shopId,
                search: state.search,
                type: state.type,
              ),
            );
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount:
                state.hasReachedMax
                    ? state.transactions.length
                    : state.transactions.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.transactions.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final transaction = state.transactions[index];
              return _TransactionTile(transaction: transaction);
            },
          ),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCashIn = transaction.type == TransactionType.CASH_IN;
    final color = isCashIn ? Colors.green.shade700 : Colors.red.shade700;
    final icon = isCashIn ? Icons.arrow_downward : Icons.arrow_upward;

    String title = transaction.description ?? 'Transaction';
    if (transaction.relatedCustomer != null) {
      title = 'Payment from ${transaction.relatedCustomer!.name}';
    } else if (transaction.relatedSupplier != null) {
      title = 'Payment to ${transaction.relatedSupplier!.name}';
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        '${transaction.category.name.replaceAll('_', ' ')} • ${DateFormat.yMMMd().format(transaction.transactionDate)}',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Text(
        '${isCashIn ? '+' : '-'} Rs. ${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      onTap: () {
        // TODO: Navigate to Transaction Detail View
      },
    );
  }
}
