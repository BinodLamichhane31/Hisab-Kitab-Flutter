import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/services/shake_detection_test.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/more/help_and_support_view.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/more/privacy_policy_view.dart';
import 'package:hisab_kitab/features/home/presentation/view/bottom_view/profile_page_view.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_view_model.dart';
import 'package:hisab_kitab/features/notification/presentation/view/notification_view.dart';
import 'package:hisab_kitab/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:hisab_kitab/features/shops/presentation/view/create_shop_view.dart';
import 'package:hisab_kitab/features/shops/presentation/view_model/shop_view_model.dart';
import 'package:hisab_kitab/features/purchases/presentation/view/purchase_view.dart';
import 'package:hisab_kitab/features/sales/presentation/view/sales_view.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view/suppliers_page_view.dart';
import 'package:hisab_kitab/features/transactions/presentation/view/transaction_view.dart';
import 'package:hisab_kitab/core/common/shortcut_buttons.dart';
import 'package:hisab_kitab/core/session/session_state.dart';

import 'package:hisab_kitab/features/auth/presentation/view/login_view.dart';
import 'package:hisab_kitab/features/home/presentation/view_model/home_state.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Account & Management'),
          _buildOptionCard(
            context: context,
            options: [
              _OptionItem(
                icon: Icons.person_outline,
                title: 'Profile',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => BlocProvider(
                            create: (context) => serviceLocator<SessionCubit>(),
                            child: const ProfilePageView(),
                          ),
                    ),
                  );
                },
              ),
              _OptionItem(
                icon: Icons.store_outlined,
                title: 'Manage Shop',
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SuppliersPageView(),
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Reports & Activity'),
          _buildOptionCard(
            context: context,
            options: [
              _OptionItem(
                icon: FontAwesomeIcons.chartLine,
                title: 'Sales',
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SalesView()),
                    ),
              ),
              _OptionItem(
                icon: Icons.shopping_cart_outlined,
                title: 'Purchase',
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PurchasesView()),
                    ),
              ),
              _OptionItem(
                icon: Icons.receipt_long_outlined,
                title: 'Transactions',
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TransactionsView(),
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'General'),
          _buildOptionCard(
            context: context,
            options: [
              _OptionItem(
                icon: Icons.star_border_purple500_outlined,
                title: 'Subscription',
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProfilePageView(),
                      ),
                    ),
              ),
              _OptionItem(
                icon: Icons.support_agent_outlined,
                title: 'Help and Support',
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HelpAndSupportView(),
                      ),
                    ),
              ),
              _OptionItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyView(),
                      ),
                    ),
              ),
              _OptionItem(
                icon: Icons.phone_android,
                title: 'Test Shake Detection',
                onTap:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ShakeDetectionTestWidget(),
                      ),
                    ),
              ),

            ],
          ),
          const SizedBox(height: 32),

          _buildLogoutTile(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required List<_OptionItem> options,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return _buildListTile(
            context: context,
            icon: option.icon,
            title: option.title,
            onTap: option.onTap,
          );
        },
        separatorBuilder:
            (context, index) => Divider(
              height: 1,
              indent: 68,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.orange),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.orange.withOpacity(0.6),
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: () => context.read<HomeViewModel>().logout(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.error.withOpacity(0.3)),
      ),
      tileColor: colorScheme.errorContainer.withOpacity(0.5),
      leading: Icon(Icons.logout, color: colorScheme.error),
      title: Text(
        'Logout',
        style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _OptionItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _OptionItem({required this.icon, required this.title, required this.onTap});
}
