import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import '../../../core/theme/styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color? color;
  final Color? textColor;

  const AppButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: (isDisabled || isLoading) ? null : onPressed,
        borderRadius: BorderRadius.circular(100), // Full rounded corners
        splashColor: Colors.white.withOpacity(0.2), // Optional splash effect
        highlightColor: Colors.transparent, // Remove default ink highlight
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: (isDisabled || isLoading) ? 0.5 : 1.0,
          child: ElevatedButton(
            onPressed: (isDisabled || isLoading) ? null : onPressed,
            style: AppButtonStyles.primaryButtonStyle.copyWith(
              backgroundColor:
                  WidgetStateProperty.all(color ?? AppColors.primary),
              foregroundColor:
                  WidgetStateProperty.all(textColor ?? Colors.white),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
            ),
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: Platform.isIOS
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                  )
                : Text(
                    label,
                    style: AppTextStyles.buttonText16SB.copyWith(
                      color: textColor ?? Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class OutlinedAppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color? borderColor;
  final Color? textColor;

  const OutlinedAppButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: (isDisabled || isLoading) ? null : onPressed,
        borderRadius: BorderRadius.circular(100), // Full rounded corners
        splashColor:
            AppColors.primary.withOpacity(0.1), // Optional splash effect
        highlightColor: Colors.transparent, // Remove default ink highlight
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: (isDisabled || isLoading) ? 0.5 : 1.0,
          child: OutlinedButton(
            onPressed: (isDisabled || isLoading) ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: textColor ?? AppColors.primary,
              side: BorderSide(
                  color: borderColor ?? AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: Colors.transparent, // For text color
            ),
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: Platform.isIOS
                        ? CupertinoActivityIndicator(
                            color: textColor ?? AppColors.primary)
                        : CircularProgressIndicator(
                            color: textColor ?? AppColors.primary,
                            strokeWidth: 2,
                          ),
                  )
                : Text(
                    label,
                    style: AppTextStyles.buttonText16SB.copyWith(
                      color: textColor ?? AppColors.primary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class SecondaryAppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color? color;
  final Color? textColor;

  const SecondaryAppButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.color,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: (isDisabled || isLoading) ? null : onPressed,
        borderRadius: BorderRadius.circular(100), // Full rounded corners
        splashColor: Colors.white.withOpacity(0.2), // Optional splash effect
        highlightColor: Colors.transparent, // Remove default ink highlight
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: (isDisabled || isLoading) ? 0.5 : 1.0,
          child: ElevatedButton(
            onPressed: (isDisabled || isLoading) ? null : onPressed,
            style: AppButtonStyles.primaryButtonStyle.copyWith(
              backgroundColor:
                  WidgetStateProperty.all(color ?? AppColors.grayBackground),
              foregroundColor:
                  WidgetStateProperty.all(textColor ?? AppColors.bodyTextColor),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
            ),
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: Platform.isIOS
                        ? const CupertinoActivityIndicator(
                            color: AppColors.bodyTextColor,
                          )
                        : const CircularProgressIndicator(
                            color: AppColors.bodyTextColor,
                            strokeWidth: 2,
                          ),
                  )
                : Text(
                    label,
                    style: AppTextStyles.buttonText16SB.copyWith(
                      color: textColor ?? AppColors.bodyTextColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
