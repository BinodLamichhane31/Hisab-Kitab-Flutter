import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/core/session/session_cubit.dart';
import 'package:hisab_kitab/core/session/session_state.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          if (state.isLoading && state.user == null) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }
          if (state.user == null) {
            return const Center(child: Text('Could not load profile data.'));
          }

          final user = state.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                _buildProfileHeader(
                  context,
                  user.fname,
                  user.lname,
                  user.email,
                ),
                const SizedBox(height: 30),
                _buildInfoCard(context, user.email, user.phone),
                const SizedBox(height: 40),
                _buildUpdateButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.orange,
              child: const CircleAvatar(
                radius: 52,
                backgroundImage: AssetImage('assets/images/profile_image.png'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surface,
                border: Border.all(color: theme.colorScheme.surface, width: 2),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '$firstName $lastName',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, String email, String phone) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _InfoTile(icon: Icons.email_outlined, label: "Email", value: email),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: theme.dividerColor.withOpacity(0.5),
          ),
          _InfoTile(
            icon: Icons.phone_outlined,
            label: "Phone Number",
            value: phone,
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {},
        icon: const Icon(Icons.edit),
        label: const Text("UPDATE PROFILE"),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
