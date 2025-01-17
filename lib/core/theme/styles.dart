import 'package:flutter/material.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

// Define text styles
class AppTextStyles {
  static const TextStyle buttonText16SB = TextStyle(
    fontFamily: 'JK_Sans',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    textBaseline: TextBaseline.alphabetic,
  );
}

// Define button style
class AppButtonStyles {
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      textStyle: AppTextStyles.buttonText16SB,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      disabledBackgroundColor: AppColors.disabled);
}
