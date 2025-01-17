import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackArrow;
  final VoidCallback? onBackPressed;
  final Widget? actionIcon;
  final double height;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackArrow = true, // Show back arrow by default
    this.onBackPressed,
    this.actionIcon,
    this.height = 56.0, // Default height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0x40BEBEBE),
              offset: const Offset(0, 4),
              blurRadius: 21.0,
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (showBackArrow)
                    InkWell(
                      onTap: onBackPressed ?? () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: SvgPicture.string(
                            SvgIcons.arrowLeftIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  if (showBackArrow) const SizedBox(width: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'JK_Sans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bodyTextColor,
                    ),
                  ),
                ],
              ),
              if (actionIcon != null) actionIcon!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
