import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/add_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_event.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_state.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_view_model.dart';

void showAddCustomerDialog(BuildContext context) {
  final activeShop = context.read<SessionCubit>().state.activeShop;

  if (activeShop == null) {
    showMySnackBar(
      context: context,
      message: 'Please select a shop first.',
      color: Colors.red,
    );
    return;
  }

  showDialog(
    context: context,
    builder: (_) {
      return BlocProvider(
        create:
            (context) => CustomerViewModel(
              getCustomersByShopUsecase:
                  serviceLocator<GetCustomersByShopUsecase>(),
              addCustomerUsecase: serviceLocator<AddCustomerUsecase>(),
              shopId: activeShop.shopId!,
            ),
        child: const AddCustomerDialog(),
      );
    },
  );
}

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({super.key});

  @override
  State<AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  void _saveCustomer() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final customerViewModel = context.read<CustomerViewModel>();
    customerViewModel.add(
      CreateCustomerEvent(
        shopId: customerViewModel.shopId,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        currentBalance: 0.0,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: BlocListener<CustomerViewModel, CustomerState>(
        listener: (context, state) {
          if (!state.isLoading) {
            if (state.errorMessage != null) {
              showMySnackBar(
                context: context,
                message: 'Error: ${state.errorMessage}',
                color: Colors.red,
              );
            } else {
              if (state.customers.any(
                (c) => c.name == _nameController.text.trim(),
              )) {
                showMySnackBar(
                  context: context,
                  message:
                      'Customer "${_nameController.text.trim()}" added successfully!',
                );
                Navigator.of(context).pop(true);
              }
            }
          }
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'New Customer',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter the details for the new customer.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      _buildTextFormField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _phoneController,
                        labelText: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _emailController,
                        labelText: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _addressController,
                        labelText: 'Address',
                        icon: Icons.location_on_outlined,
                        required: true,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -40,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.orange,
                child: const Icon(
                  Icons.person_add_alt_1,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.05),
      ),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return '$labelText is required';
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<CustomerViewModel, CustomerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed:
                  state.isLoading ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                // <<< ADDED to set button color
                backgroundColor: Colors.orange,
              ),
              icon:
                  state.isLoading
                      ? Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Icon(Icons.save, color: Colors.white),
              label: const Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: state.isLoading ? null : _saveCustomer,
            ),
          ],
        );
      },
    );
  }
}
