import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/common/snackbar/my_snackbar.dart';
import 'package:hisab_kitab/features/customers/domain/entity/customer_entity.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/delete_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/get_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/domain/use_case/update_customer_usecase.dart';
import 'package:hisab_kitab/features/customers/presentation/view/widget/customer_form_dialog.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_detail_event.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_detail_state.dart';
import 'package:hisab_kitab/features/customers/presentation/view_model/customer_detail_view_model.dart';
import 'package:intl/intl.dart';

class CustomerDetailPage extends StatelessWidget {
  final String customerId;

  const CustomerDetailPage({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CustomerDetailViewModel(
            getCustomerByIdUsecase: serviceLocator<GetCustomerUsecase>(),
            deleteCustomerUsecase: serviceLocator<DeleteCustomerUsecase>(),
            updateCustomerUsecase: serviceLocator<UpdateCustomerUsecase>(),
          )..add(LoadCustomerDetailEvent(customerId)),
      child: const CustomerDetailView(),
    );
  }
}

class CustomerDetailView extends StatelessWidget {
  const CustomerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerDetailViewModel, CustomerDetailState>(
      listener: (context, state) {
        if (state.status == CustomerDetailStatus.deleted) {
          showMySnackBar(
            context: context,
            message: 'Customer deleted successfully.',
          );
          Navigator.of(context).pop(true);
        }
        if (state.errorMessage != null) {
          showMySnackBar(
            context: context,
            message: state.errorMessage!,
            color: Colors.red,
          );
          context.read<CustomerDetailViewModel>().emit(
            state.copyWith(clearError: true),
          );
        }
      },
      builder: (context, state) {
        final customer = state.customer;
        return Scaffold(
          appBar: AppBar(
            title: Text(customer?.name ?? 'Customer Detail'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            actions: [
              if (customer != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    showCustomerFormDialog(context, customerToEdit: customer);
                  },
                ),
              if (customer != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(context, customer),
                ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, CustomerEntity customer) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Customer?'),
          content: Text(
            'Are you sure you want to delete "${customer.name}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                context.read<CustomerDetailViewModel>().add(
                  DeleteCustomerEvent(customer.customerId!),
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

  Widget _buildBody(BuildContext context, CustomerDetailState state) {
    if (state.status == CustomerDetailStatus.loading ||
        state.status == CustomerDetailStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == CustomerDetailStatus.failure ||
        state.customer == null) {
      return Center(
        child: Text(state.errorMessage ?? 'Failed to load customer data.'),
      );
    }

    final customer = state.customer!;
    final initials =
        customer.name.isNotEmpty
            ? customer.name.trim().split(' ').map((e) => e[0]).take(2).join()
            : '?';

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: _buildHeader(context, customer, initials),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                const TabBar(
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.orange,
                  tabs: [
                    Tab(icon: Icon(Icons.person_outline), text: "Overview"),
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
            _buildOverviewTab(customer),
            _buildDetailsTab(customer),
            const Center(child: Text("Transactions will be shown here.")),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    CustomerEntity customer,
    String initials,
  ) {
    // Assuming registration date is part of the customerId's timestamp
    final registeredDate =
        customer.customerId != null
            ? DateFormat('dd/MM/yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                int.parse(customer.customerId!.substring(0, 8), radix: 16) *
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
            customer.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Customer since $registeredDate',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(CustomerEntity customer) {
    final registeredDate =
        customer.customerId != null
            ? DateFormat('dd/MM/yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                int.parse(customer.customerId!.substring(0, 8), radix: 16) *
                    1000,
              ),
            )
            : 'N/A';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _StatCard(
            icon: Icons.receipt,
            title: 'Total Received',
            value: 'Rs. 0.00',
            color: Colors.orange.shade700,
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.account_balance_wallet,
            title: 'Current Balance',
            value: 'Rs. ${customer.currentBalance.toStringAsFixed(2)}',
            color: Colors.blue.shade700,
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.calendar_today,
            title: 'Registered Date',
            value: registeredDate,
            color: Colors.green.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(CustomerEntity customer) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        ListTile(
          leading: const Icon(Icons.phone_outlined, color: Colors.orange),
          title: const Text('Phone'),
          subtitle: Text(customer.phone),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.email_outlined, color: Colors.orange),
          title: const Text('Email'),
          subtitle: Text(customer.email),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.orange),
          title: const Text('Address'),
          subtitle: Text(
            customer.address.isNotEmpty
                ? customer.address
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
