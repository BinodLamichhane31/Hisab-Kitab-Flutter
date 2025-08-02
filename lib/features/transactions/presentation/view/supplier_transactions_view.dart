import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/transactions/domain/use_case/get_transactions_usecase.dart';
import 'package:hisab_kitab/features/transactions/presentation/view_model/transaction_view_model.dart';
import 'package:hisab_kitab/features/transactions/presentation/view/transactions_view.dart';

class SupplierTransactionsView extends StatelessWidget {
  final String supplierId;
  final String supplierName;

  const SupplierTransactionsView({
    super.key,
    required this.supplierId,
    required this.supplierName,
  });

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
          key: ValueKey('${activeShop.shopId}_$supplierId'),
          create:
              (context) => TransactionViewModel(
                getTransactionsUsecase:
                    serviceLocator<GetTransactionsUsecase>(),
                shopId: activeShop.shopId!,
              ),
          child: FilteredTransactionsList(
            shopId: activeShop.shopId!,
            supplierId: supplierId,
            title: '$supplierName Transactions',
            supplierName: supplierName,
          ),
        );
      },
    );
  }
}
