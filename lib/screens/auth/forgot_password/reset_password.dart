import 'package:flutter/material.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
// import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailControllerProvider = Provider((ref) => TextEditingController());

class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  void _login(WidgetRef ref) async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _emailController = ref.watch(emailControllerProvider);

    void _goToVerifyScreen() {
      Navigator.pushNamed(context, AppRoute.verifyOTPScreen);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              'Reset Your Password',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: "JK_Sans",
                  color: AppColors.bodyTextColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              'We need your email s we can send you the reset code',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: "JK_Sans",
                  color: AppColors.subTitleTextColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
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
            SizedBox(height: 32),
            AppButton(
              label: "Send Code",
              onPressed: _goToVerifyScreen,
            ),
          ],
        ),
      ),
    );
  }
}
