import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/products/domain/entity/product_entity.dart';
import 'package:hisab_kitab/features/purchases/domain/use_case/create_purchase_usecase.dart';
import 'package:hisab_kitab/features/purchases/presentation/view/supplier_selection_bottom_sheet.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/create_purchase_event.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/create_purchase_state.dart';
import 'package:hisab_kitab/features/purchases/presentation/view_model/create_purchase_view_model.dart';
import 'package:hisab_kitab/features/sales/presentation/view/product_selection_bottom_sheet.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:intl/intl.dart';

InputDecoration _buildInputDecoration({
  required String labelText,
  String? prefixText,
  String? hintText,
  IconData? prefixIcon,
  TextStyle? errorStyle,
}) {
  const orangeColor = Colors.orange;
  final orangeBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: orangeColor, width: 1.5),
  );

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    prefixText: prefixText,
    prefixIcon:
        prefixIcon != null ? Icon(prefixIcon, color: orangeColor) : null,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    focusedBorder: orangeBorder,
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    errorStyle: errorStyle,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
  );
}

class CreatePurchaseView extends StatelessWidget {
  const CreatePurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final shopId = context.read<SessionCubit>().state.activeShop?.shopId;
    if (shopId == null) {
      return const Scaffold(body: Center(child: Text("No active shop found.")));
    }

    return BlocProvider(
      create:
          (_) => CreatePurchaseViewModel(
            createPurchaseUsecase: serviceLocator<CreatePurchaseUsecase>(),
            shopId: shopId,
          ),
      child: const _CreatePurchaseContent(),
    );
  }
}

class _CreatePurchaseContent extends StatefulWidget {
  const _CreatePurchaseContent();
  @override
  State<_CreatePurchaseContent> createState() => _CreatePurchaseContentState();
}

class _CreatePurchaseContentState extends State<_CreatePurchaseContent> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePurchaseViewModel, CreatePurchaseState>(
      listener: (context, state) {
        if (state.status == CreatePurchaseStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Purchase created successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          Navigator.of(context).pop(true);
        } else if (state.status == CreatePurchaseStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == CreatePurchaseStatus.loading;
        return Scaffold(
          appBar: AppBar(title: const Text('Create New Purchase')),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SupplierDetailsCard(state: state),
                  const SizedBox(height: 16),
                  _PurchaseItemsCard(state: state),
                  const SizedBox(height: 16),
                  _OrderSummaryCard(state: state),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<CreatePurchaseViewModel>().add(
                                    SubmitPurchase(),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill all required fields correctly.',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                }
                              },
                      icon:
                          isLoading
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(Icons.check_circle_outline),
                      label: Text(
                        isLoading ? 'Saving...' : 'Complete Purchase',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SupplierDetailsCard extends StatelessWidget {
  final CreatePurchaseState state;
  const _SupplierDetailsCard({required this.state});

  void _showSupplierSelectionSheet(BuildContext context) async {
    final viewModel = context.read<CreatePurchaseViewModel>();
    final selectedSupplier = await showModalBottomSheet<SupplierEntity>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const SupplierSelectionBottomSheet(),
    );
    if (selectedSupplier != null && context.mounted) {
      viewModel.add(SupplierSelected(selectedSupplier));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CreatePurchaseViewModel>();
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Supplier & Details', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: SegmentedButton<bool>(
                style: SegmentedButton.styleFrom(
                  selectedForegroundColor: Colors.white,
                  selectedBackgroundColor: Colors.orange,
                ),
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text('Cash Purchase'),
                    icon: Icon(Icons.money_outlined),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('Credit Purchase'),
                    icon: Icon(Icons.local_shipping_outlined),
                  ),
                ],
                selected: {state.isCashPurchase},
                onSelectionChanged:
                    (selection) =>
                        viewModel.add(TogglePurchaseType(selection.first)),
              ),
            ),
            const SizedBox(height: 16),
            if (state.isCashPurchase)
              const ListTile(
                leading: Icon(Icons.storefront, color: Colors.orange),
                title: Text('Cash Transaction'),
              )
            else ...[
              Text('Purchased From', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.orange),
                title: Text(
                  state.selectedSupplier?.name ?? 'Select a Supplier',
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color:
                        state.errorMessage != null &&
                                state.selectedSupplier == null
                            ? Colors.red
                            : Colors.grey.shade300,
                  ),
                ),
                onTap: () => _showSupplierSelectionSheet(context),
              ),
              if (state.errorMessage != null && state.selectedSupplier == null)
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    state.errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              decoration: _buildInputDecoration(
                labelText: 'Notes (Optional)',
                prefixIcon: Icons.note_add_outlined,
              ),
              onChanged: (value) => viewModel.add(FieldChanged(notes: value)),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseItemsCard extends StatelessWidget {
  final CreatePurchaseState state;
  const _PurchaseItemsCard({required this.state});

  void _showProductSelectionSheet(BuildContext context) async {
    final viewModel = context.read<CreatePurchaseViewModel>();
    final alreadyAddedIds =
        state.items.map((item) => item.product.productId!).toSet();
    final selectedProducts = await showModalBottomSheet<List<ProductEntity>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => ProductSelectionBottomSheet(
            alreadyAddedProductIds: alreadyAddedIds,
          ),
    );
    if (selectedProducts != null &&
        selectedProducts.isNotEmpty &&
        context.mounted) {
      viewModel.add(ProductsAdded(selectedProducts));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CreatePurchaseViewModel>();
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Purchase Items', style: theme.textTheme.titleLarge),
                FilledButton.icon(
                  onPressed: () => _showProductSelectionSheet(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: FilledButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
            const Divider(height: 24),
            if (state.items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  'No products added yet. Add at least one product.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return _PurchaseItemTile(item: item, viewModel: viewModel);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseItemTile extends StatelessWidget {
  final PurchaseFormItem item;
  final CreatePurchaseViewModel viewModel;
  const _PurchaseItemTile({required this.item, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.orange),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed:
                      () => viewModel.add(ItemRemoved(item.product.productId!)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: item.quantity.toString(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration(
                      labelText: 'Qty',
                      errorStyle: const TextStyle(height: 0.01),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged:
                        (val) => viewModel.add(
                          ItemQuantityChanged(
                            item.product.productId!,
                            int.tryParse(val) ?? 1,
                          ),
                        ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Req.';
                      final qty = int.tryParse(val);
                      if (qty == null) return 'Invalid';
                      if (qty <= 0) return '> 0';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: item.unitCost.toStringAsFixed(2),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration(
                      labelText: 'Unit Cost',
                      prefixText: 'Rs. ',
                      errorStyle: const TextStyle(height: 0.01),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged:
                        (val) => viewModel.add(
                          ItemCostChanged(
                            item.product.productId!,
                            double.tryParse(val) ?? 0.0,
                          ),
                        ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Req.';
                      final price = double.tryParse(val);
                      if (price == null) return 'Invalid';
                      if (price < 0) return '>= 0';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: InputDecorator(
                    decoration: _buildInputDecoration(labelText: 'Total'),
                    child: Text(
                      'Rs. ${item.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final CreatePurchaseState state;
  const _OrderSummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CreatePurchaseViewModel>();
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: 'Rs. ');

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary', style: theme.textTheme.titleLarge),
            const Divider(height: 24),
            _buildSummaryRow(
              theme,
              'Subtotal',
              currencyFormat.format(state.subTotal),
            ),
            _buildEditableRow(
              state,
              'Discount',
              state.discount,
              (val) => viewModel.add(
                FieldChanged(discount: double.tryParse(val) ?? 0.0),
              ),
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              theme,
              'Grand Total',
              currencyFormat.format(state.grandTotal),
              isBold: true,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: state.amountPaid.toStringAsFixed(2),
              key: ValueKey(
                'amount_paid_${state.grandTotal}_${state.isCashPurchase}',
              ),
              decoration: _buildInputDecoration(
                labelText: 'Amount Paid',
                prefixText: 'Rs. ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged:
                  (val) => viewModel.add(
                    FieldChanged(amountPaid: double.tryParse(val) ?? 0.0),
                  ),
              readOnly: state.isCashPurchase,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Required';
                final amount = double.tryParse(val);
                if (amount == null) return 'Invalid amount';
                if (amount < 0) return 'Cannot be negative';
                if (amount > state.grandTotal + 0.01)
                  return 'Exceeds total'; // Add tolerance for double
                return null;
              },
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: _buildSummaryRow(
                theme,
                'Amount Due',
                currencyFormat.format(state.amountDue),
                isBold: true,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.orange.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    ThemeData theme,
    String title,
    String value, {
    bool isBold = false,
    TextStyle? style,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: style ?? theme.textTheme.bodyLarge),
          Text(
            value,
            style: (style ?? theme.textTheme.bodyLarge)?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow(
    CreatePurchaseState state,
    String title,
    double value,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(title),
            ),
          ),
          SizedBox(
            width: 150,
            child: TextFormField(
              initialValue: value.toStringAsFixed(2),
              decoration: _buildInputDecoration(
                labelText: title,
                prefixText: 'Rs. ',
              ),
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: onChanged,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Req.';
                final numValue = double.tryParse(val);
                if (numValue == null) return 'Invalid';
                if (numValue < 0) return '>= 0';
                if (title == 'Discount' && numValue > state.subTotal)
                  return 'Exceeds subtotal';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
