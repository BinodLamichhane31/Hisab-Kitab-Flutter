import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});

  Future<void> _launchWebsite() async {
    const url = 'https://binodlamichhane.com.np';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = Colors.orange;
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Pro'),
        backgroundColor: iconColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(Icons.star, size: 64, color: iconColor),
                    const SizedBox(height: 20),
                    Text(
                      'Upgrade to Pro',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Unlock unlimited features and take your business to the next level',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureItem('Unlimited Shops', isDark),
                    const SizedBox(height: 8),
                    _buildFeatureItem('AI Hisab Assistant', isDark),
                    const SizedBox(height: 8),
                    _buildFeatureItem('Priority Support', isDark),
                    const SizedBox(height: 8),
                    _buildFeatureItem('Advanced Analytics', isDark),
                    const SizedBox(height: 8),
                    _buildFeatureItem('Custom Reports', isDark),
                    const SizedBox(height: 32),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: iconColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '₹1000',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: iconColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '/ year',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            Card(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.language, size: 48, color: iconColor),
                    const SizedBox(height: 16),
                    Text(
                      'Visit Our Website',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get more information about our services and features',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _launchWebsite,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: iconColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Visit Website'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isDark) {
    return Row(
      children: [
        Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
