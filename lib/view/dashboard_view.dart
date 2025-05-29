import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hamburger Icon
            Icon(Icons.menu),

            // Business Name Dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Text(
                    "Business Name",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),

            // Notification Icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              padding: EdgeInsets.all(10),
              child: Icon(Icons.notifications_none, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
