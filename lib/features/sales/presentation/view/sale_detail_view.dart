import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_entity.dart';
import 'package:hisab_kitab/features/sales/domain/entity/sale_enums.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/cancel_sale_usecase.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/get_sale_by_id_usecase.dart';
import 'package:hisab_kitab/features/sales/domain/use_case/record_payment_usecase.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_detail_event.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_detail_state.dart';
import 'package:hisab_kitab/features/sales/presentation/view_model/sale_detail_view_model.dart';
import 'package:intl/intl.dart';

class SaleDetailView extends StatelessWidget {
  final String saleId;

  const SaleDetailView({super.key, required this.saleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SaleDetailViewModel(
            getSaleByIdUsecase: serviceLocator<GetSaleByIdUsecase>(),
            cancelSaleUsecase: serviceLocator<CancelSaleUsecase>(),
            recordPaymentUsecase: serviceLocator<RecordPaymentUsecase>(),
            saleId: saleId,
          ),
      child: const _SaleDetailContent(),
    );
  }
}

class _SaleDetailContent extends StatelessWidget {
  const _SaleDetailContent();

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              isError ? Colors.red.shade600 : Colors.green.shade600,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleDetailViewModel, SaleDetailState>(
      listener: (context, state) {
        if (state.status == SaleDetailStatus.error &&
            state.errorMessage != null) {
          _showSnackBar(context, state.errorMessage!, isError: true);
        } else if (state.successMessage != null) {
          _showSnackBar(context, state.successMessage!);
          // Pop and return true to notify the previous screen to refresh the list
          if (state.status == SaleDetailStatus.cancelled ||
              state.status == SaleDetailStatus.paymentRecorded) {
            Navigator.of(context).pop(true);
          }
        }
      },
      builder: (context, state) {
        final sale = state.sale;
        final isLoading = state.status == SaleDetailStatus.loading;

        return Scaffold(
          appBar: AppBar(
            title: Text(sale?.invoiceNumber ?? 'Sale Details'),
            actions: [
              if (sale != null)
                IconButton(
                  icon: const Icon(Icons.print_outlined),
                  tooltip: 'Print Invoice',
                  onPressed: () {
                    /* TODO: Implement printing logic */
                  },
                ),
            ],
          ),
          body: Stack(
            children: [
              _buildBody(context, state),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SaleDetailState state) {
    switch (state.status) {
      case SaleDetailStatus.initial:
        // Loading is handled by the overlay, so initial can show a spinner too.
        return const Center(child: CircularProgressIndicator());

      case SaleDetailStatus.error:
        if (state.sale == null) {
          // Only show full-screen error if no data is available
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? 'An unknown error occurred.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<SaleDetailViewModel>().add(
                        LoadSaleDetailEvent(
                          saleId: context.read<SaleDetailViewModel>().saleId,
                        ),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        // If there's an error but we have stale data, show the data. The error is shown in the snackbar.
        return _SaleDetails(sale: state.sale!);

      case SaleDetailStatus.loading:
      case SaleDetailStatus.success:
      case SaleDetailStatus.cancelled:
      case SaleDetailStatus.paymentRecorded:
        if (state.sale == null) {
          return const Center(child: Text('Sale not found.'));
        }
        return _SaleDetails(sale: state.sale!);
    }
  }
}

class _SaleDetails extends StatelessWidget {
  final SaleEntity sale;
  const _SaleDetails({required this.sale});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs. ',
    );
    final bool canCancel = sale.status != SaleStatus.CANCELLED;
    final bool canRecordPayment =
        sale.status != SaleStatus.CANCELLED &&
        sale.paymentStatus != PaymentStatus.PAID;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: 16),

          // Action Buttons
          if (canCancel || canRecordPayment)
            _buildActionButtons(context, canRecordPayment, canCancel),

          const SizedBox(height: 24),

          // Customer & Sale Info
          _buildInfoCards(context),
          const SizedBox(height: 16),

          // Items Table
          _buildItemsCard(context, currencyFormat),
          const SizedBox(height: 16),

          // Financials
          _buildFinancialsCard(context, currencyFormat),
          const SizedBox(height: 16),

          // Notes
          if (sale.notes != null && sale.notes!.isNotEmpty)
            _buildNotesCard(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice #${sale.invoiceNumber}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Recorded on ${DateFormat.yMMMd().add_jm().format(sale.saleDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        _StatusBadge(status: sale.paymentStatus, saleStatus: sale.status),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool canRecordPayment,
    bool canCancel,
  ) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (canRecordPayment)
          ElevatedButton.icon(
            onPressed: () => _showRecordPaymentDialog(context),
            icon: const Icon(Icons.payment, color: Colors.white),
            label: const Text(
              'Record Payment',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        if (canCancel)
          ElevatedButton.icon(
            onPressed: () => _showCancelConfirmationDialog(context),
            icon: const Icon(Icons.cancel_outlined, color: Colors.white),
            label: const Text(
              'Cancel Sale',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
      ],
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCustomerInfo(context),
            const Divider(height: 32),
            _buildSaleMetadata(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Billed To',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        sale.customer != null
            ? ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.person_outline),
                backgroundColor: Colors.orange,
              ),
              title: Text(
                sale.customer!.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(sale.customer!.phone ?? 'No contact number'),
            )
            : ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.store_outlined)),
              title: Text(
                'Walk-in Customer',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
      ],
    );
  }

  Widget _buildSaleMetadata(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          context,
          'Sale Date:',
          DateFormat.yMMMd().format(sale.saleDate),
        ),
        const SizedBox(height: 8),
        _buildDetailRow(context, 'Sale Type:', sale.saleType.name),
        // Add Created By if available in your entity
        // const SizedBox(height: 8),
        // _buildDetailRow(context, 'Created By:', sale.createdBy ?? 'N/A'),
      ],
    );
  }

  Widget _buildItemsCard(BuildContext context, NumberFormat currencyFormat) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Items', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            DataTable(
              horizontalMargin: 0,
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('Product')),
                DataColumn(label: Text('Qty'), numeric: true),
                DataColumn(label: Text('Rate'), numeric: true),
                DataColumn(label: Text('Total'), numeric: true),
              ],
              rows:
                  sale.items
                      .map(
                        (item) => DataRow(
                          cells: [
                            DataCell(Text(item.productName)),
                            DataCell(Text(item.quantity.toString())),
                            DataCell(
                              Text(currencyFormat.format(item.priceAtSale)),
                            ),
                            DataCell(Text(currencyFormat.format(item.total))),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialsCard(
    BuildContext context,
    NumberFormat currencyFormat,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFinancialRow(
              context,
              'Subtotal',
              currencyFormat.format(sale.subTotal),
            ),
            _buildFinancialRow(
              context,
              'Discount',
              '- ${currencyFormat.format(sale.discount)}',
            ),
            _buildFinancialRow(
              context,
              'Tax',
              '+ ${currencyFormat.format(sale.tax)}',
            ),
            const Divider(height: 24),
            _buildFinancialRow(
              context,
              'Grand Total',
              currencyFormat.format(sale.grandTotal),
              isBold: true,
            ),
            _buildFinancialRow(
              context,
              'Amount Paid',
              currencyFormat.format(sale.amountPaid),
              valueColor: Colors.green.shade700,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.errorContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildFinancialRow(
                context,
                'Amount Due',
                currencyFormat.format(sale.amountDue),
                isBold: true,
                textStyle: Theme.of(context).textTheme.titleLarge,
                valueColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Notes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(sale.notes!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildFinancialRow(
    BuildContext context,
    String title,
    String value, {
    bool isBold = false,
    Color? valueColor,
    TextStyle? textStyle,
  }) {
    final style = textStyle ?? Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: style?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: style?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    final viewModel = context.read<SaleDetailViewModel>();
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Confirm Cancellation'),
            content: Text(
              'Are you sure you want to cancel Invoice #${sale.invoiceNumber}? This will restock items and reverse any transactions. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                child: const Text('Back'),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Yes, Cancel Sale'),
                onPressed: () {
                  viewModel.add(CancelSaleEvent(saleId: sale.saleId!));
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
    );
  }

  void _showRecordPaymentDialog(BuildContext context) {
    final viewModel = context.read<SaleDetailViewModel>();
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(
      text: sale.amountDue.toStringAsFixed(2),
    );
    String paymentMethod = 'CASH';

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Record Payment'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Amount Paid',
                      labelStyle: TextStyle(color: Colors.orange),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      hintText:
                          'Amount Due: ${sale.amountDue.toStringAsFixed(2)}',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Amount is required.';
                      final amount = double.tryParse(value);
                      if (amount == null) return 'Please enter a valid number.';
                      if (amount <= 0) return 'Amount must be positive.';
                      if (amount > sale.amountDue)
                        return 'Cannot pay more than amount due.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: paymentMethod,
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      labelStyle: TextStyle(color: Colors.orange),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      border: OutlineInputBorder(),
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
                      if (value != null) paymentMethod = value;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.orange),
                ),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              ElevatedButton(
                child: const Text(
                  'Save Payment',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    viewModel.add(
                      RecordPaymentEvent(
                        saleId: sale.saleId!,
                        amountPaid: double.parse(amountController.text),
                        paymentMethod: paymentMethod,
                      ),
                    );
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
            ],
          ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PaymentStatus status;
  final SaleStatus saleStatus;

  const _StatusBadge({required this.status, required this.saleStatus});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    Color textColor;

    if (saleStatus == SaleStatus.CANCELLED) {
      text = 'Cancelled';
      color = Colors.grey.shade300;
      textColor = Colors.grey.shade800;
    } else {
      switch (status) {
        case PaymentStatus.PAID:
          text = 'Paid';
          color = Colors.green.shade100;
          textColor = Colors.green.shade900;
          break;
        case PaymentStatus.PARTIAL:
          text = 'Partial';
          color = Colors.orange.shade100;
          textColor = Colors.orange.shade900;
          break;
        case PaymentStatus.UNPAID:
          text = 'Unpaid';
          color = Colors.red.shade100;
          textColor = Colors.red.shade900;
          break;
        case PaymentStatus.CANCELLED:
          text = 'Cancelled';
          color = Colors.red.shade100;
          textColor = Colors.red.shade900;
          break;
      }
    }

    return Chip(
      label: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}
