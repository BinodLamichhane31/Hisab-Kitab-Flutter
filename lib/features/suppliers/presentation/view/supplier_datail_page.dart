import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/features/suppliers/domain/entity/supplier_entity.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/delete_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/get_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/domain/use_case/update_supplier_usecase.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view/supplier_form_dialog.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_detail_event.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_detail_state.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view_model/supplier_detail_view_model.dart';
import 'package:intl/intl.dart';

class SupplierDetailPage extends StatelessWidget {
  final String supplierId;

  const SupplierDetailPage({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SupplierDetailViewModel(
            getSupplierByIdUsecase: serviceLocator<GetSupplierUsecase>(),
            deleteSupplierUsecase: serviceLocator<DeleteSupplierUsecase>(),
            updateSupplierUsecase: serviceLocator<UpdateSupplierUsecase>(),
          )..add(LoadSupplierDetailEvent(supplierId)),
      child: const SupplierDetailView(),
    );
  }
}

class SupplierDetailView extends StatelessWidget {
  const SupplierDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupplierDetailViewModel, SupplierDetailState>(
      listener: (context, state) {
        if (state.status == SupplierDetailStatus.deleted) {
          showMySnackBar(
            context: context,
            message: 'Supplier deleted successfully.',
          );
          Navigator.of(context).pop(true);
        }
        if (state.errorMessage != null) {
          showMySnackBar(
            context: context,
            message: state.errorMessage!,
            color: Colors.red,
          );
          context.read<SupplierDetailViewModel>().emit(
            state.copyWith(clearError: true),
          );
        }
      },
      builder: (context, state) {
        final supplier = state.supplier;
        return Scaffold(
          appBar: AppBar(
            title: Text(supplier?.name ?? 'Supplier Detail'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            actions: [
              if (supplier != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    showSupplierFormDialog(context, supplierToEdit: supplier);
                  },
                ),
              if (supplier != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(context, supplier),
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, SupplierEntity supplier) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Supplier?'),
          content: Text(
            'Are you sure you want to delete "${supplier.name}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<SupplierDetailViewModel>().add(
                  DeleteSupplierEvent(supplier.supplierId!),
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SupplierDetailState state) {
    if (state.status == SupplierDetailStatus.loading ||
        state.status == SupplierDetailStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == SupplierDetailStatus.failure ||
        state.supplier == null) {
      return Center(
        child: Text(state.errorMessage ?? 'Failed to load supplier data.'),
      );
    }

    final supplier = state.supplier!;
    final initials =
        supplier.name.isNotEmpty
            ? supplier.name.trim().split(' ').map((e) => e[0]).take(2).join()
            : '?';

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: _buildHeader(context, supplier, initials),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                const TabBar(
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.orange,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.storefront_outlined),
                      text: "Overview",
                    ),
                    Tab(
                      icon: Icon(Icons.receipt_long_outlined),
                      text: "Details",
                    ),
                    Tab(
                      icon: Icon(Icons.swap_horiz_outlined),
                      text: "Transactions",
                    ),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          children: [
            _buildOverviewTab(supplier),
            _buildDetailsTab(supplier),
            const Center(child: Text("Transactions will be shown here.")),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    SupplierEntity supplier,
    String initials,
  ) {
    final registeredDate =
        supplier.supplierId != null
            ? DateFormat('dd/MM/yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                int.parse(supplier.supplierId!.substring(0, 8), radix: 16) *
                    1000,
              ),
            )
            : 'N/A';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.orange,
            child: Text(
              initials.toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            supplier.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Supplier since $registeredDate',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(SupplierEntity supplier) {
    final registeredDate =
        supplier.supplierId != null
            ? DateFormat('dd/MM/yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                int.parse(supplier.supplierId!.substring(0, 8), radix: 16) *
                    1000,
              ),
            )
            : 'N/A';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _StatCard(
            icon: Icons.local_shipping_outlined,
            title: 'Total Purchased',
            value: 'Rs. 0.00',
            color: Colors.orange.shade700,
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Current Balance',
            value: 'Rs. ${supplier.currentBalance.toStringAsFixed(2)}',
            color: Colors.blue.shade700,
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.calendar_today_outlined,
            title: 'Registered Date',
            value: registeredDate,
            color: Colors.green.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(SupplierEntity supplier) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        ListTile(
          leading: const Icon(Icons.phone_outlined, color: Colors.orange),
          title: const Text('Phone'),
          subtitle: Text(supplier.phone),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.email_outlined, color: Colors.orange),
          title: const Text('Email'),
          subtitle: Text(supplier.email),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.orange),
          title: const Text('Address'),
          subtitle: Text(
            supplier.address.isNotEmpty
                ? supplier.address
                : 'No address provided',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
