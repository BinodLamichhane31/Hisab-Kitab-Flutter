import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:hisab_kitab/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});
  final _formKey = GlobalKey<FormState>();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black38 : Color(0xFFF4F4F4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new),
                  ),
                ),
                Text(
                  "Create Account",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _fnameController,
                  decoration: InputDecoration(
                    labelText: "First Name",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    prefixIcon: Align(
                      heightFactor: 1,
                      widthFactor: 1,
                      child: Icon(Icons.person_outlined),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _lnameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    prefixIcon: Align(
                      heightFactor: 1,
                      widthFactor: 1,
                      child: Icon(Icons.person_outlined),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange),
                    ),

                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.phone_outlined),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone number is required.";
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.email_outlined),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText:
                      !context.watch<SignupViewModel>().state.isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.key_outlined),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        final isVisible =
                            context
                                .read<SignupViewModel>()
                                .state
                                .isPasswordVisible;
                        context.read<SignupViewModel>().add(
                          ShowHidePassword(
                            context: context,
                            isVisible: !isVisible,
                          ),
                        );
                      },
                      icon: Icon(
                        context.watch<SignupViewModel>().state.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText:
                      !context
                          .watch<SignupViewModel>()
                          .state
                          .isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    prefixIcon: Align(
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: Icon(Icons.key_outlined),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        final isVisible =
                            context
                                .read<SignupViewModel>()
                                .state
                                .isConfirmPasswordVisible;
                        context.read<SignupViewModel>().add(
                          ShowHideConfirmPassword(
                            context: context,
                            isVisible: !isVisible,
                          ),
                        );
                      },
                      icon: Icon(
                        context
                                .watch<SignupViewModel>()
                                .state
                                .isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (_confirmPasswordController.text !=
                        _passwordController.text) {
                      return 'Password and confirm password must be same.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignupViewModel>().add(
                          RegisterUserEvent(
                            context: context,
                            fname: _fnameController.text,
                            lname: _lnameController.text,
                            phone: _phoneController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text,
                            onSuccess: () {
                              // _formKey.currentState?.reset(); // optional
                              _fnameController.clear();
                              _lnameController.clear();
                              _phoneController.clear();
                              _emailController.clear();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                            },
                          ),
                        );
                      }
                    },

                    child: Text(
                      'Create',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an accoount? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
