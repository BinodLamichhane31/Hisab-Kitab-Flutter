import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';
import 'package:hisab_kitab/core/utils/profile_fields.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        if (state.isLoading && state.user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.user == null) {
          return const Center(child: Text('Could not load profile.'));
        }

        final user = state.user!;
        final theme = Theme.of(context);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        'assets/images/profile_image.png',
                      ),
                    ),
                    const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.edit, size: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${user.fname} ${user.lname}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 30),
              buildInputField(Icons.email, "Email", user.email, theme),
              const SizedBox(height: 15),
              buildInputField(Icons.phone, "Phone Number", user.phone, theme),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                style: theme.elevatedButtonTheme.style,
                onPressed: () {
                  //Navigate to an "Edit Profile" page
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  "UPDATE PROFILE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
