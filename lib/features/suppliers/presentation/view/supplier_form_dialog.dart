import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/add_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/get_suppliers_by_shop_usecase.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_detail_event.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_detail_state.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_detail_view_model.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_event.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_state.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_view_model.dart';

void showSupplierFormDialog(
  BuildContext context, {
  SupplierEntity? supplierToEdit,
}) {
  Widget blocProvider;
  if (supplierToEdit != null) {
    blocProvider = BlocProvider.value(
      value: context.read<SupplierDetailViewModel>(),
      child: SupplierFormDialog(supplierToEdit: supplierToEdit),
    );
  } else {
    final activeShop = context.read<SessionCubit>().state.activeShop;
    if (activeShop == null) {
      showMySnackBar(
        context: context,
        message: 'Please select a shop first.',
        color: Colors.red,
      );
      return;
    }
    blocProvider = BlocProvider(
      create:
          (context) => SupplierViewModel(
            getSuppliersByShopUsecase:
                serviceLocator<GetSuppliersByShopUsecase>(),
            addSupplierUsecase: serviceLocator<AddSupplierUsecase>(),
            shopId: activeShop.shopId!,
          ),
      child: SupplierFormDialog(supplierToEdit: supplierToEdit),
    );
  }

  showDialog(context: context, builder: (_) => blocProvider).then((success) {
    if (success == true && supplierToEdit == null) {
      // ignore: use_build_context_synchronously
      final viewModel = context.read<SupplierViewModel>();
      viewModel.add(LoadSuppliersEvent(shopId: viewModel.shopId));
    }
  });
}

class SupplierFormDialog extends StatefulWidget {
  final SupplierEntity? supplierToEdit;
  const SupplierFormDialog({super.key, this.supplierToEdit});

  @override
  State<SupplierFormDialog> createState() => _SupplierFormDialogState();
}

class _SupplierFormDialogState extends State<SupplierFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  bool get _isEditing => widget.supplierToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.supplierToEdit?.name ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.supplierToEdit?.phone ?? '',
    );
    _emailController = TextEditingController(
      text: widget.supplierToEdit?.email ?? '',
    );
    _addressController = TextEditingController(
      text: widget.supplierToEdit?.address ?? '',
    );
  }

  void _onSave() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (_isEditing) {
      final updatedSupplier = SupplierEntity(
        supplierId: widget.supplierToEdit!.supplierId,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        currentBalance: widget.supplierToEdit!.currentBalance,
        totalSupplied: widget.supplierToEdit!.totalSupplied,
        shopId: widget.supplierToEdit!.shopId,
      );
      context.read<SupplierDetailViewModel>().add(
        UpdateSupplierDetailEvent(updatedSupplier),
      );
    } else {
      final supplierViewModel = context.read<SupplierViewModel>();
      supplierViewModel.add(
        CreateSupplierEvent(
          shopId: supplierViewModel.shopId,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          address: _addressController.text.trim(),
          currentBalance: 0.0,
          totalSupplied: 0.0,
        ),
      );
    }
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
    if (_isEditing) {
      // --- Build for EDIT mode ---
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: BlocConsumer<SupplierDetailViewModel, SupplierDetailState>(
          listener: (context, state) {
            if (state.status == SupplierDetailStatus.success &&
                state.supplier?.name == _nameController.text.trim()) {
              showMySnackBar(
                context: context,
                message: 'Supplier updated successfully!',
              );
              Navigator.of(context).pop(true);
            }
            if (state.errorMessage != null) {
              showMySnackBar(
                context: context,
                message: 'Error: ${state.errorMessage}',
                color: Colors.red,
              );
              // ignore: invalid_use_of_visible_for_testing_member
              context.read<SupplierDetailViewModel>().emit(
                state.copyWith(clearError: true),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == SupplierDetailStatus.loading;
            return _buildDialogContent(isLoading);
          },
        ),
      );
    } else {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: BlocConsumer<SupplierViewModel, SupplierState>(
          listener: (context, state) {
            if (!state.isLoading &&
                state.errorMessage == null &&
                _nameController.text.isNotEmpty) {
              final isNewlyAdded =
                  !state.suppliers.any(
                    (s) => s.name == _nameController.text.trim(),
                  );
              if (!isNewlyAdded) {
                showMySnackBar(
                  context: context,
                  message:
                      'Supplier "${_nameController.text.trim()}" added successfully!',
                );
                Navigator.of(context).pop(true);
              }
            } else if (state.errorMessage != null) {
              showMySnackBar(
                context: context,
                message: 'Error: ${state.errorMessage}',
                color: Colors.red,
              );
            }
          },
          builder: (context, state) {
            return _buildDialogContent(state.isLoading);
          },
        ),
      );
    }
  }

  Widget _buildDialogContent(bool isLoading) {
    return Stack(
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
                    _isEditing ? 'Edit Supplier' : 'New Supplier',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEditing
                        ? 'Update the supplier details below.'
                        : 'Enter the details for the new supplier.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _buildTextFormField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    icon: Icons.storefront_outlined,
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
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _addressController,
                    labelText: 'Address',
                    icon: Icons.location_on_outlined,
                    required: false,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),
                  _buildActionButtons(isLoading),
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
            child: Icon(
              _isEditing ? Icons.edit : Icons.add_business_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
        labelStyle: TextStyle(color: Colors.orange),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return '$labelText is required';
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons(bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: Colors.orange),
          icon:
              isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Icon(_isEditing ? Icons.save : Icons.add_business),
          label: Text(_isEditing ? 'Update' : 'Save'),
          onPressed: isLoading ? null : _onSave,
        ),
      ],
    );
  }
}
