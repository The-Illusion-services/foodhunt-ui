import 'package:flutter/material.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
// import 'package:food_hunt/providers.dart';
// import 'package:go_router/go_router.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  _CreateNewPasswordState createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushNamed(context, AppRoute.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              'Create New Password',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "JK_Sans",
                  color: AppColors.bodyTextColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              "Create a new password, please don't forget this one too.",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: "JK_Sans",
                  color: AppColors.subTitleTextColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            AppInputField(
              label: "Password",
              hintText: 'Enter new password',
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
                if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$')
                    .hasMatch(value)) {
                  return 'Password must be at least 6 characters and contain both letters and numbers';
                }
                if (_confirmPasswordController.text !=
                    _passwordController.text) {
                  return 'Passwords must match';
                }

                return null;
              },
            ),
            SizedBox(height: 32),
            AppButton(
              label: "Create new password",
              onPressed: _goToLogin,
            ),
          ],
        ),
      ),
    );
  }
}
