import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hisab_kitab/core/common/shortcut_buttons.dart';
import 'package:hisab_kitab/core/utils/trend_chart.dart';
import 'package:hisab_kitab/features/customers/presentation/view/widget/customer_form_dialog.dart';
import 'package:hisab_kitab/features/suppliers/presentation/view/supplier_form_dialog.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.people, color: Colors.blue),
                          SizedBox(height: 8),
                          Text(
                            "31",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Total Customers", textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.local_shipping, color: Colors.blue),
                          SizedBox(height: 8),
                          Text(
                            "5",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Total Suppliers", textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.arrow_downward, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Receivable Amount: "),
                  Text(
                    "Rs. 3127273.33",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.arrow_upward, color: Colors.red),
                  SizedBox(width: 10),
                  Text("Payable Amount: "),
                  Text(
                    "Rs. 2308780.98",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Trend Chart",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(height: 250, child: SalesPurchaseChart()),

            SizedBox(height: 20),
            Text(
              "Shortcuts",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2,
              children: [
                shortcut("Add Customers", Icons.group_add, () {
                  showCustomerFormDialog(context);
                }),
                shortcut("Add Suppliers", Icons.local_shipping, () {
                  showSupplierFormDialog(context);
                }),
                shortcut("Manage Stocks", Icons.shopping_cart, () {}),
                shortcut("Cash In", Icons.input, () {}),
                shortcut("Cash Out", Icons.output, () {}),
                shortcut("Sales Entry", Icons.attach_money, () {}),
                shortcut("Purchase Entry", Icons.price_change, () {}),
                shortcut("Transactions", Icons.currency_exchange, () {}),
                shortcut("Hisab Bot", FontAwesomeIcons.robot, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
