import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

class SettingsItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Row(
          children: [
            SvgPicture.string(
              icon,
              width: 24,
              height: 24,
              colorFilter:
                  ColorFilter.mode(AppColors.bodyTextColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.bodyTextColor,
                    fontFamily: "JK_Sans"),
              ),
            ),
            SvgPicture.string(
              SvgIcons.chevronRightIcon,
              width: 24,
              height: 18,
              colorFilter:
                  ColorFilter.mode(AppColors.bodyTextColor, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
