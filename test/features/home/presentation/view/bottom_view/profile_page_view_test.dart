import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisab_kitab/features/auth/domain/entity/user_entity.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/profile_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockProfileViewModel extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileViewModel {}

void main() {
  late MockProfileViewModel mockProfileViewModel;
  late UserEntity mockUser;

  setUp(() {
    mockProfileViewModel = MockProfileViewModel();
    mockUser = const UserEntity(
      userId: '1',
      fname: 'John',
      lname: 'Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      password: 'password123',
    );
  });

  void _showUpdateProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<ProfileViewModel>(),
            child: const _UpdateProfileDialog(),
          ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<ProfileViewModel>(),
            child: const _ChangePasswordDialog(),
          ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => BlocProvider.value(
            value: context.read<ProfileViewModel>(),
            child: AlertDialog(
              title: const Text('Delete Account'),
              content: const Text(
                'Are you sure you want to delete your account? This action cannot be undone.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.read<ProfileViewModel>().add(DeleteAccountEvent());
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserEntity user) {
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
          '${user.fname} ${user.lname}',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, UserEntity user) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _InfoTile(
            icon: Icons.email_outlined,
            label: "Email",
            value: user.email,
          ),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: theme.dividerColor.withOpacity(0.5),
          ),
          _InfoTile(
            icon: Icons.phone_outlined,
            label: "Phone Number",
            value: user.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => _showUpdateProfileDialog(context),
            icon: const Icon(Icons.edit),
            label: const Text("UPDATE PROFILE"),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => _showChangePasswordDialog(context),
            icon: const Icon(Icons.lock),
            label: const Text("CHANGE PASSWORD"),
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Card(
      color: Colors.red.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.red.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Danger Zone',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Once you delete your account, there is no going back. Please be certain.',
              style: TextStyle(
                color: Colors.red.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _showDeleteAccountDialog(context),
                icon: const Icon(Icons.delete_forever, size: 18),
                label: const Text("DELETE ACCOUNT"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pumpProfilePageView(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider<ProfileViewModel>.value(
        value: mockProfileViewModel,
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('My Profile')),
            body: BlocConsumer<ProfileViewModel, ProfileState>(
              listener: (context, state) {
                // Handle state changes if needed
              },
              builder: (context, state) {
                if (state is ProfileLoaded || state is ProfileSuccess) {
                  UserEntity? user;
                  if (state is ProfileLoaded) {
                    user = state.user;
                  } else if (state is ProfileSuccess) {
                    user = state.user;
                  }

                  if (user != null) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          _buildProfileHeader(context, user),
                          const SizedBox(height: 30),
                          _buildInfoCard(context, user),
                          const SizedBox(height: 20),
                          _buildActionButtons(context),
                          const SizedBox(height: 20),
                          _buildDangerZone(context),
                        ],
                      ),
                    );
                  }
                }

                if (state is ProfileLoading || state is ProfileInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                return const Center(
                  child: Text('Could not load profile data.'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  group('ProfilePageView Action Buttons', () {
    testWidgets('shows CHANGE PASSWORD button', (WidgetTester tester) async {
      when(
        () => mockProfileViewModel.state,
      ).thenReturn(ProfileLoaded(mockUser));

      await pumpProfilePageView(tester);
      await tester.pumpAndSettle();

      expect(find.text('CHANGE PASSWORD'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('shows DELETE ACCOUNT button in danger zone', (
      WidgetTester tester,
    ) async {
      when(
        () => mockProfileViewModel.state,
      ).thenReturn(ProfileLoaded(mockUser));

      await pumpProfilePageView(tester);
      await tester.pumpAndSettle();

      expect(find.text('DELETE ACCOUNT'), findsOneWidget);
      expect(find.text('Danger Zone'), findsOneWidget);
      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
    });

    testWidgets(
      'opens update profile dialog when UPDATE PROFILE button is tapped',
      (WidgetTester tester) async {
        when(
          () => mockProfileViewModel.state,
        ).thenReturn(ProfileLoaded(mockUser));

        await pumpProfilePageView(tester);
        await tester.pumpAndSettle();

        await tester.tap(find.text('UPDATE PROFILE'));
        await tester.pumpAndSettle();

        expect(find.text('Update Profile'), findsOneWidget);
        expect(find.text('First Name *'), findsOneWidget);
        expect(find.text('Last Name *'), findsOneWidget);
      },
    );
    testWidgets('validates update profile form fields', (
      WidgetTester tester,
    ) async {
      when(
        () => mockProfileViewModel.state,
      ).thenReturn(ProfileLoaded(mockUser));

      await pumpProfilePageView(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('UPDATE PROFILE'));
      await tester.pumpAndSettle();

      // Try to submit without entering data
      await tester.tap(find.text('Update'));
      await tester.pump();

      expect(find.text('First name is required'), findsOneWidget);
      expect(find.text('Last name is required'), findsOneWidget);
    });
  });
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

class _UpdateProfileDialog extends StatefulWidget {
  const _UpdateProfileDialog();

  @override
  State<_UpdateProfileDialog> createState() => _UpdateProfileDialogState();
}

class _UpdateProfileDialogState extends State<_UpdateProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Profile'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _fnameController,
              decoration: const InputDecoration(
                labelText: 'First Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'First name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lnameController,
              decoration: const InputDecoration(
                labelText: 'Last Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Last name is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Update'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileViewModel>().add(
        UpdateProfileEvent(
          fname: _fnameController.text.trim(),
          lname: _lnameController.text.trim(),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password *',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current password is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password *',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password *',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Change Password'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileViewModel>().add(
        ChangePasswordEvent(
          oldPassword: _oldPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
