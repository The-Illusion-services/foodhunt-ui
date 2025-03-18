import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';

class PreLoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<PreLoginScreen> createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends ConsumerState<PreLoginScreen> {
  // int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    AppAssets.user_onboarding,
                    height: 229,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Food Journey Starts Here!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "JK_Sans",
                      color: AppColors.bodyTextColor,
                    ),
                    textAlign: TextAlign.left,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Discover top restaurants near you. Sign up to order, customize, and track your meals!",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: "JK_Sans",
                      color: AppColors.subTitleTextColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Column(
                    children: [
                      AppButton(
                          label: "Sign up",
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppRoute.userSignUpScreen);
                          }),
                      const SizedBox(
                        height: 12,
                      ),
                      SecondaryAppButton(
                          label: "Log in",
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoute.loginScreen);
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
