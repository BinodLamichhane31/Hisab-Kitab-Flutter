// lib/features/more/presentation/view/privacy_policy_view.dart

import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Colors.orange;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy'), elevation: 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Our Commitment to Your Privacy',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Updated: October 26, 2023',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              title: '1. Information We Collect',
              content:
                  'We collect information to provide better services to all our users. This includes information you provide when you create an account, such as your name, email address, and phone number. We also collect data generated from your use of our services, including transaction details, sales records, and purchase history.',
            ),
            _buildSection(
              context,
              title: '2. How We Use Information',
              content:
                  'The information we collect is used to operate, maintain, and improve our services. We use your data to personalize content, process transactions, provide customer support, and for internal analytics to understand how our services are used. We will not share your personal information with companies, organizations, or individuals outside of Hisab Kitab except with your explicit consent.',
            ),
            _buildSection(
              context,
              title: '3. Data Security',
              content:
                  'We work hard to protect Hisab Kitab and our users from unauthorized access to or unauthorized alteration, disclosure, or destruction of information we hold. We use encryption to keep your data private while in transit and review our information collection, storage, and processing practices to prevent unauthorized access to our systems.',
            ),
            _buildSection(
              context,
              title: '4. Changes to This Policy',
              content:
                  'We may change this Privacy Policy from time to time. We will post any privacy policy changes on this page and, if the changes are significant, we will provide a more prominent notice. We encourage you to review the Privacy Policy whenever you access the Services to stay informed about our information practices.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.justify,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
