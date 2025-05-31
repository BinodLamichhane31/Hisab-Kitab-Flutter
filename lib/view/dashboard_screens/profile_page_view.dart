import 'package:flutter/material.dart';
import 'package:hisab_kitab/utils/profile_fields.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/images/profile_image.png',
                  ),
                ),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: theme.primaryColor,
                  child: Icon(Icons.edit, size: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Binod Lamichhane",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 30),
          buildInputField(Icons.email, "Email", "abc@gmail.com", theme),
          SizedBox(height: 15),
          buildInputField(
            Icons.phone,
            "Phone Number",
            "+977-9800000000",
            theme,
          ),
          SizedBox(height: 15),
          buildInputField(
            Icons.calendar_today,
            "Date of Birth",
            "yyyy-mm-dd",
            theme,
          ),
          SizedBox(height: 15),
          buildInputField(Icons.male, "Gender", "Male", theme),
          SizedBox(height: 15),
          buildInputField(Icons.location_on, "Address", "Kathmandu", theme),
          SizedBox(height: 25),
          ElevatedButton.icon(
            style: theme.elevatedButtonTheme.style,
            onPressed: () {},
            icon: Icon(Icons.edit, color: Colors.white),
            label: Text(
              "UPDATE PROFILE",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
