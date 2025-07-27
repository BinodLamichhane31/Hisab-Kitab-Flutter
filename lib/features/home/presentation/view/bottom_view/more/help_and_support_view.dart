import 'package:flutter/material.dart';

class HelpAndSupportView extends StatelessWidget {
  const HelpAndSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Colors.orange;

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Frequently Asked Questions',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildFaqItem(
              context,
              question: 'How do I add a new customer?',
              answer:
                  'Navigate to the "Shortcuts" section on your dashboard and tap "Add Customer". Fill in the required details and save. You can also add customers directly from the new sale creation screen.',
            ),
            _buildFaqItem(
              context,
              question: 'Can I use this app on multiple devices?',
              answer:
                  'Yes! Your data is synced to your account. You can log in on any supported device and your shop data, transactions, and reports will be available instantly.',
            ),
            _buildFaqItem(
              context,
              question: 'How is my data backed up?',
              answer:
                  'We automatically and securely back up your data to the cloud in real-time. You never have to worry about losing your business records.',
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(height: 48),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Contact Us',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildContactTile(
              context,
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'support@hisabkitab.app',
              onTap: () {},
            ),
            _buildContactTile(
              context,
              icon: Icons.phone_outlined,

              title: 'Call Us',
              subtitle: '+977 9841XXXXXX',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ExpansionTile(
      iconColor: colorScheme.primary,
      collapsedIconColor: colorScheme.primary.withOpacity(0.7),
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.85),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Colors.orange;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colorScheme.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: colorScheme),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        subtitle,
        // Adaptive subtitle color
        style: TextStyle(color: colorScheme.withOpacity(0.7)),
      ),
    );
  }
}
