import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/common/shortcut_buttons.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view/widget/trend_chart.dart';
import 'package:hisab_kitab/features/customers/presentation/view/widget/customer_form_dialog.dart';
import 'package:hisab_kitab/features/dashboard/domain/entity/dashboard_stats_entity.dart';
import 'package:hisab_kitab/features/dashboard/domain/use_case/get_dashboard_data_usecase.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view_model/dashboard_event.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view_model/dashboard_state.dart';
import 'package:hisab_kitab/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:hisab_kitab/features/purchases/presentation/view/create_purchase_view.dart';
import 'package:hisab_kitab/features/sales/presentation/view/create_sale_view.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view/supplier_form_dialog.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen: (p, c) => p.activeShop?.shopId != c.activeShop?.shopId,
      builder: (context, sessionState) {
        final activeShop = sessionState.activeShop;
        if (activeShop == null || activeShop.shopId == null) {
          return const Scaffold(
            body: Center(child: Text('Please select a shop.')),
          );
        }
        return BlocProvider(
          key: ValueKey(activeShop.shopId),
          create:
              (_) => DashboardViewModel(
                getDashboardDataUsecase:
                    serviceLocator<GetDashboardDataUsecase>(),
                shopId: activeShop.shopId!,
              )..add(LoadDashboardData()),
          child: const _DashboardContent(),
        );
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardViewModel, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading &&
              state.dashboardData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == DashboardStatus.error &&
              state.dashboardData == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'Failed to load dashboard.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<DashboardViewModel>().add(
                          LoadDashboardData(),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.dashboardData != null) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardViewModel>().add(LoadDashboardData());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatsGrid(stats: state.dashboardData!.stats),
                    const SizedBox(height: 16),
                    _FinancialSummary(stats: state.dashboardData!.stats),
                    const SizedBox(height: 24),
                    const Text(
                      "Trend Chart",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 250,
                      child: SalesPurchaseChart(
                        data: state.dashboardData!.chartData,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Shortcuts",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _ShortcutsGrid(),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Welcome to your Dashboard!'));
        },
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final DashboardStatsEntity stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.people,
            label: "Total Customers",
            value: stats.totalCustomers.toString(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.local_shipping,
            label: "Total Suppliers",
            value: stats.totalSuppliers.toString(),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _FinancialSummary extends StatelessWidget {
  final DashboardStatsEntity stats;
  const _FinancialSummary({required this.stats});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: 'Rs. ',
    );
    return Column(
      children: [
        _FinancialRow(
          label: "Receivable Amount:",
          amount: stats.receivableAmount,
          color: Colors.green,
          icon: Icons.arrow_downward,
          formatter: currencyFormat,
        ),
        const SizedBox(height: 10),
        _FinancialRow(
          label: "Payable Amount:",
          amount: stats.payableAmount,
          color: Colors.red,
          icon: Icons.arrow_upward,
          formatter: currencyFormat,
        ),
      ],
    );
  }
}

class _FinancialRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final NumberFormat formatter;

  const _FinancialRow({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(label),
          const Spacer(),
          Text(
            formatter.format(amount),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ShortcutsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 3 / 2,
      children: [
        shortcut("Add Customers", Icons.group_add, () {
          showCustomerFormDialog(context);
        }),
        shortcut("Add Suppliers", FontAwesomeIcons.truckFast, () {
          showSupplierFormDialog(context);
        }),
        shortcut("Cash In", Icons.input, () {}),
        shortcut("Cash Out", Icons.output, () {}),
        shortcut("Sales Entry", Icons.attach_money, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateSaleView()),
          );
        }),
        shortcut("Purchase Entry", Icons.price_change, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePurchaseView()),
          );
        }),
        shortcut("Hisab Bot", FontAwesomeIcons.robot, () {}),
      ],
    );
  }
}
