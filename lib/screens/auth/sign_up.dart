import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';

import '../../widgets/inputs/phone_input.dart';

final firstNameControllerProvider = Provider((ref) => TextEditingController());
final lastNameControllerProvider = Provider((ref) => TextEditingController());
final emailControllerProvider = Provider((ref) => TextEditingController());
final passwordControllerProvider = Provider((ref) => TextEditingController());
final confirmPasswordControllerProvider =
    Provider((ref) => TextEditingController());

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  void _login() async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _firstNameController = ref.watch(firstNameControllerProvider);
    final _lastNameController = ref.watch(lastNameControllerProvider);
    final _emailController = ref.watch(emailControllerProvider);
    final _passwordController = ref.watch(passwordControllerProvider);
    final _confirmPasswordController =
        ref.watch(confirmPasswordControllerProvider);

    void _goToLogin() async {
      Navigator.pushNamed(context, AppRoute.loginScreen);
    }

    void _goToVerifyEmail() async {
      Navigator.pushNamed(context, AppRoute.verifyEmailScreen);
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Create an Account',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "JK_Sans",
                      color: AppColors.bodyTextColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Enter your details below',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: "JK_Sans",
                      color: AppColors.subTitleTextColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                AppInputField(
                  label: "First Name",
                  hintText: 'Enter first name',
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                AppInputField(
                  label: "Last Name",
                  hintText: 'Enter last name',
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last name is required';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                AppInputField(
                  label: "Email",
                  hintText: 'Enter email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // CustomPhoneInput(
                //   label: 'Phone number',
                //   hintText: 'Enter phone number',
                //   controller: _emailController,
                // ),
                PhoneNumberInput(
                  label: "Phone number",
                  hintText: 'Enter phone number',
                  controller: _passwordController,
                ),
                SizedBox(height: 20),
                AppInputField(
                  label: "Password",
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$')
                        .hasMatch(value)) {
                      return 'Password must be at least 6 characters and contain both letters and numbers';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                AppInputField(
                  label: "Confirm Password",
                  hintText: 'Confirm your password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 32),
                AppButton(
                  label: "Sign Up",
                  onPressed: _goToVerifyEmail,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color(0xFFE5E7EB),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                            color: AppColors.subTitleTextColor,
                            fontSize: 12,
                            fontFamily: "JK_Sans",
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color(0xFFE5E7EB),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    AppAssets.google,
                    height: 24,
                    width: 24,
                  ),
                  label: Text(
                    'Google',
                    style: TextStyle(
                      color: AppColors.bodyTextColor,
                      fontFamily: "JK_Sans",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: AppColors.bodyTextColor,
                    backgroundColor: AppColors.grayBackground,
                    side: BorderSide(color: AppColors.grayBorderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minimumSize: Size(double.infinity, 50), // Full width
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: TextStyle(
                              color: AppColors.grayTextColor,
                              fontFamily: "JK_Sans",
                              fontSize: 14)),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: _goToLogin,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontFamily: "JK_Sans",
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]),
              ],
            ),
          ),
        ));
  }
}
