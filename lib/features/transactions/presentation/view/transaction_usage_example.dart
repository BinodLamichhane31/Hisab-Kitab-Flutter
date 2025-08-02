import 'package:flutter/material.dart';
import 'package:hisab_kitab/features/transactions/presentation/view/customer_transactions_view.dart';
import 'package:hisab_kitab/features/transactions/presentation/view/supplier_transactions_view.dart';
import 'package:hisab_kitab/features/transactions/presentation/view/transactions_view.dart';

/// Example usage of the new transaction list components
///
/// This file demonstrates how to use the transaction list components
/// in different scenarios:
///
/// 1. General transactions view (all transactions for a shop)
/// 2. Customer-specific transactions view
/// 3. Supplier-specific transactions view
///
/// Usage Examples:
///
/// 1. For general transactions (all transactions in a shop):
///    ```dart
///    Navigator.push(
///      context,
///      MaterialPageRoute(
///        builder: (context) => const TransactionsView(),
///      ),
///    );
///    ```
///
/// 2. For customer-specific transactions:
///    ```dart
///    Navigator.push(
///      context,
///      MaterialPageRoute(
///        builder: (context) => CustomerTransactionsView(
///          customerId: 'customer_id_here',
///          customerName: 'Customer Name',
///        ),
///      ),
///    );
///    ```
///
/// 3. For supplier-specific transactions:
///    ```dart
///    Navigator.push(
///      context,
///      MaterialPageRoute(
///        builder: (context) => SupplierTransactionsView(
///          supplierId: 'supplier_id_here',
///          supplierName: 'Supplier Name',
///        ),
///      ),
///    );
///    ```
///
/// Features:
/// - Automatic filtering by customer/supplier ID
/// - Search functionality
/// - Pull-to-refresh
/// - Infinite scrolling
/// - Loading states
/// - Error handling
/// - Responsive design
///
/// The components automatically handle:
/// - Session management (active shop)
/// - State management (BLoC pattern)
/// - API calls with proper error handling
/// - UI updates based on transaction type (cash in/out)
/// - Date formatting
/// - Amount formatting with currency symbol

class TransactionUsageExample extends StatelessWidget {
  const TransactionUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction List Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildExampleCard(
            context,
            'General Transactions',
            'View all transactions for the current shop',
            Icons.list,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransactionsView()),
            ),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            'Customer Transactions',
            'View transactions for a specific customer',
            Icons.person,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const CustomerTransactionsView(
                      customerId: 'example_customer_id',
                      customerName: 'John Doe',
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            context,
            'Supplier Transactions',
            'View transactions for a specific supplier',
            Icons.business,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const SupplierTransactionsView(
                      supplierId: 'example_supplier_id',
                      supplierName: 'ABC Supplies',
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
