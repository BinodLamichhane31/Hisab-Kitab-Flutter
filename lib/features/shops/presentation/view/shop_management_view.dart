import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/features/shops/domain/entity/shop_entity.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_event.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_state.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';

class ShopManagementView extends StatelessWidget {
  const ShopManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ShopViewModel(
            getAllShopsUsecase: serviceLocator(),
            createShopUsecase: serviceLocator(),
          ),
      child: const _ShopManagementViewContent(),
    );
  }
}

class _ShopManagementViewContent extends StatelessWidget {
  const _ShopManagementViewContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Shops')),
      body: BlocConsumer<ShopViewModel, ShopState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            showMySnackBar(
              context: context,
              message: state.errorMessage!,
              color: Colors.red,
            );
          }
          if (state.successMessage != null) {
            showMySnackBar(
              context: context,
              message: state.successMessage!,
              color: Colors.green,
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          return Column(
            children: [
              // Header with shop count
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.orange.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(Icons.store, color: Colors.orange, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Your Shops (${state.shops.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Shops list
              Expanded(
                child:
                    state.shops.isEmpty
                        ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.store_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No shops found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add your first shop to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.shops.length,
                          itemBuilder: (context, index) {
                            final shop = state.shops[index];
                            return _ShopCard(shop: shop);
                          },
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddShopDialog(context),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddShopDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const _AddShopDialog());
  }
}

class _ShopCard extends StatelessWidget {
  final ShopEntity shop;

  const _ShopCard({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: Icon(Icons.store, color: Colors.orange),
        ),
        title: Text(
          shop.shopName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shop.address != null && shop.address!.isNotEmpty)
              Text(shop.address!, style: const TextStyle(fontSize: 12)),
            if (shop.contactNumber != null && shop.contactNumber!.isNotEmpty)
              Text(shop.contactNumber!, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditShopDialog(context, shop);
                break;
              case 'delete':
                _showDeleteConfirmation(context, shop);
                break;
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
        ),
      ),
    );
  }

  void _showEditShopDialog(BuildContext context, ShopEntity shop) {
    showDialog(
      context: context,
      builder: (context) => _EditShopDialog(shop: shop),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ShopEntity shop) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Shop'),
            content: Text(
              'Are you sure you want to delete "${shop.shopName}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Implement delete shop functionality
                  showMySnackBar(
                    context: context,
                    message: 'Delete functionality coming soon',
                    color: Colors.orange,
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}

class _AddShopDialog extends StatefulWidget {
  const _AddShopDialog();

  @override
  State<_AddShopDialog> createState() => _AddShopDialogState();
}

class _AddShopDialogState extends State<_AddShopDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Shop'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Shop Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Shop name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Shop'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ShopViewModel>().add(
        CreateShopEvent(
          shopName: _nameController.text.trim(),
          address: _addressController.text.trim(),
          contactNumber: _contactController.text.trim(),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}

class _EditShopDialog extends StatefulWidget {
  final ShopEntity shop;

  const _EditShopDialog({required this.shop});

  @override
  State<_EditShopDialog> createState() => _EditShopDialogState();
}

class _EditShopDialogState extends State<_EditShopDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shop.shopName);
    _addressController = TextEditingController(text: widget.shop.address ?? '');
    _contactController = TextEditingController(
      text: widget.shop.contactNumber ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Shop'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Shop Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Shop name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Update Shop'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement update shop functionality
      showMySnackBar(
        context: context,
        message: 'Update functionality coming soon',
        color: Colors.orange,
      );
      Navigator.of(context).pop();
    }
  }
}
