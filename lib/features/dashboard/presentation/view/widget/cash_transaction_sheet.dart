import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_in_usecase.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/record_cash_out_usecase.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:intl/intl.dart';

enum PaymentType { cashIn, cashOut }

class CashTransactionSheet extends StatefulWidget {
  final PaymentType type;
  final dynamic entity;
  final String shopId;

  const CashTransactionSheet({
    super.key,
    required this.type,
    required this.entity,
    required this.shopId,
  });

  @override
  State<CashTransactionSheet> createState() => _CashTransactionSheetState();
}

class _CashTransactionSheetState extends State<CashTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _paymentMethod = 'CASH';

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = context.read<DashboardViewModel>();
    final amount = double.parse(_amountController.text);

    if (widget.type == PaymentType.cashIn) {
      final customer = widget.entity as CustomerEntity;
      viewModel.add(
        RecordCashInSubmitted(
          RecordCashInParams(
            shopId: widget.shopId,
            customerId: customer.customerId!,
            amount: amount,
            paymentMethod: _paymentMethod,
            notes: _notesController.text,
          ),
        ),
      );
    } else {
      final supplier = widget.entity as SupplierEntity;
      viewModel.add(
        RecordCashOutSubmitted(
          RecordCashOutParams(
            shopId: widget.shopId,
            supplierId: supplier.supplierId!,
            amount: amount,
            paymentMethod: _paymentMethod,
            notes: _notesController.text,
          ),
        ),
      );
    }
    Navigator.of(context).pop(); // Close the sheet after submission
  }

  @override
  Widget build(BuildContext context) {
    final isCashIn = widget.type == PaymentType.cashIn;
    final name =
        isCashIn
            ? (widget.entity as CustomerEntity).name
            : (widget.entity as SupplierEntity).name;
    final balance =
        isCashIn
            ? (widget.entity as CustomerEntity).currentBalance
            : (widget.entity as SupplierEntity).currentBalance;
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs. ',
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCashIn ? 'Record Cash In from' : 'Record Cash Out to',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isCashIn ? Colors.green : Colors.red).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isCashIn ? 'Total Receivable:' : 'Total Payable:',
                    style: TextStyle(
                      color:
                          (isCashIn
                              ? Colors.green.shade800
                              : Colors.red.shade800),
                    ),
                  ),
                  Text(
                    currencyFormat.format(balance),
                    style: TextStyle(
                      color:
                          (isCashIn
                              ? Colors.green.shade800
                              : Colors.red.shade800),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount to ${isCashIn ? 'Receive' : 'Pay'}',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
                prefixText: 'Rs. ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Amount is required.';
                }
                final amount = double.tryParse(value);
                if (amount == null) return 'Please enter a valid number.';
                if (amount <= 0) return 'Amount must be positive.';
                if (amount > balance) {
                  return 'Amount cannot exceed the balance.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
              items:
                  ['CASH', 'BANK_TRANSFER', 'CARD', 'OTHER']
                      .map(
                        (method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _paymentMethod = value);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(isCashIn ? 'Record Payment' : 'Make Payment'),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isCashIn ? Colors.green.shade700 : Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
