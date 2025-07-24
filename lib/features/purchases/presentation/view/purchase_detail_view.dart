import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/entity/purchase_enums.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/cancel_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/get_purchase_by_id_usecase.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/record_payment_for_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_detail_event.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_detail_state.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/purchase_detail_view_model.dart';
import 'package:intl/intl.dart';

class PurchaseDetailView extends StatelessWidget {
  final String purchaseId;
  const PurchaseDetailView({super.key, required this.purchaseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => PurchaseDetailViewModel(
            getPurchaseByIdUsecase: serviceLocator<GetPurchaseByIdUsecase>(),
            cancelPurchaseUsecase: serviceLocator<CancelPurchaseUsecase>(),
            recordPaymentUsecase:
                serviceLocator<RecordPaymentForPurchaseUsecase>(),
            purchaseId: purchaseId,
          ),
      child: const _PurchaseDetailContent(),
    );
  }
}

class _PurchaseDetailContent extends StatelessWidget {
  const _PurchaseDetailContent();

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
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseDetailViewModel, PurchaseDetailState>(
      listener: (context, state) {
        if (state.status == PurchaseDetailStatus.error &&
            state.errorMessage != null) {
          _showSnackBar(context, state.errorMessage!, isError: true);
        } else if (state.successMessage != null) {
          _showSnackBar(context, state.successMessage!);
          if (state.status == PurchaseDetailStatus.cancelled ||
              state.status == PurchaseDetailStatus.paymentRecorded) {
            Navigator.of(context).pop(true); // Return true to refresh list
          }
        }
      },
      builder: (context, state) {
        final isLoading = state.status == PurchaseDetailStatus.loading;
        return Scaffold(
          appBar: AppBar(
            title: Text(state.purchase?.billNumber ?? 'Purchase Details'),
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

  Widget _buildBody(BuildContext context, PurchaseDetailState state) {
    if (state.status == PurchaseDetailStatus.initial &&
        state.purchase == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == PurchaseDetailStatus.error && state.purchase == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage ?? 'An unknown error occurred.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  () => context.read<PurchaseDetailViewModel>().add(
                    LoadPurchaseDetailEvent(
                      purchaseId:
                          context.read<PurchaseDetailViewModel>().purchaseId,
                    ),
                  ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (state.purchase == null) {
      return const Center(child: Text('Purchase not found.'));
    }
    return _PurchaseDetails(purchase: state.purchase!);
  }
}

class _PurchaseDetails extends StatelessWidget {
  final PurchaseEntity purchase;
  const _PurchaseDetails({required this.purchase});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs. ',
    );
    final canCancel = purchase.status != PurchaseStatus.CANCELLED;
    final canRecordPayment =
        purchase.status != PurchaseStatus.CANCELLED &&
        purchase.paymentStatus != PaymentStatus.PAID &&
        purchase.purchaseType == PurchaseType.SUPPLIER;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          if (canCancel || canRecordPayment)
            _buildActionButtons(context, canRecordPayment, canCancel),
          const SizedBox(height: 24),
          _buildInfoCards(context),
          const SizedBox(height: 16),
          _buildItemsCard(context, currencyFormat),
          const SizedBox(height: 16),
          _buildFinancialsCard(context, currencyFormat),
          const SizedBox(height: 16),
          if (purchase.notes != null && purchase.notes!.isNotEmpty)
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
                'Bill #${purchase.billNumber}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Recorded on ${DateFormat.yMMMd().add_jm().format(purchase.purchaseDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        _StatusBadge(
          status: purchase.paymentStatus,
          purchaseStatus: purchase.status,
        ),
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
              'Cancel Purchase',
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
            _buildSupplierInfo(context),
            const Divider(height: 32),
            _buildPurchaseMetadata(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purchased From',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),
        purchase.supplier != null
            ? ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                child: const Icon(Icons.local_shipping_outlined),
                backgroundColor: Colors.teal.shade300,
              ),
              title: Text(
                purchase.supplier!.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(purchase.supplier!.phone ?? 'No contact number'),
            )
            : ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.money_outlined)),
              title: Text(
                'Cash Purchase',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
      ],
    );
  }

  Widget _buildPurchaseMetadata(BuildContext context) {
    return Column(
      children: [
        _buildDetailRow(
          context,
          'Purchase Date:',
          DateFormat.yMMMd().format(purchase.purchaseDate),
        ),
        const SizedBox(height: 8),
        _buildDetailRow(context, 'Purchase Type:', purchase.purchaseType.name),
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
                DataColumn(label: Text('Cost'), numeric: true),
                DataColumn(label: Text('Total'), numeric: true),
              ],
              rows:
                  purchase.items
                      .map(
                        (item) => DataRow(
                          cells: [
                            DataCell(Text(item.productName)),
                            DataCell(Text(item.quantity.toString())),
                            DataCell(
                              Text(currencyFormat.format(item.unitCost)),
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
              currencyFormat.format(purchase.subTotal),
            ),
            _buildFinancialRow(
              context,
              'Discount',
              '- ${currencyFormat.format(purchase.discount)}',
            ),
            const Divider(height: 24),
            _buildFinancialRow(
              context,
              'Grand Total',
              currencyFormat.format(purchase.grandTotal),
              isBold: true,
            ),
            _buildFinancialRow(
              context,
              'Amount Paid',
              currencyFormat.format(purchase.amountPaid),
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
                currencyFormat.format(purchase.amountDue),
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
            Text(
              purchase.notes!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
    final viewModel = context.read<PurchaseDetailViewModel>();
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Confirm Cancellation'),
            content: Text(
              'Are you sure you want to cancel Bill #${purchase.billNumber}? This will remove items from stock and reverse transactions. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                child: const Text('Back'),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Yes, Cancel Purchase'),
                onPressed: () {
                  viewModel.add(
                    CancelPurchaseEvent(purchaseId: purchase.purchaseId!),
                  );
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
    );
  }

  void _showRecordPaymentDialog(BuildContext context) {
    final viewModel = context.read<PurchaseDetailViewModel>();
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(
      text: purchase.amountDue.toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Record Payment'),
            content: Form(
              key: formKey,
              child: TextFormField(
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
                      'Amount Due: ${purchase.amountDue.toStringAsFixed(2)}',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required.';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) return 'Please enter a valid number.';
                  if (amount <= 0) return 'Amount must be positive.';
                  if (amount > (purchase.amountDue + 0.01)) {
                    return 'Cannot pay more than amount due.';
                  }
                  return null;
                },
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Save Payment',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    viewModel.add(
                      RecordPaymentEvent(
                        purchaseId: purchase.purchaseId!,
                        amountPaid: double.parse(amountController.text),
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
  final PurchaseStatus purchaseStatus;
  const _StatusBadge({required this.status, required this.purchaseStatus});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    Color textColor;

    if (purchaseStatus == PurchaseStatus.CANCELLED) {
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
        case PaymentStatus
            .CANCELLED: // This state might not be used if purchaseStatus is primary
          text = 'Cancelled';
          color = Colors.grey.shade300;
          textColor = Colors.grey.shade800;
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
