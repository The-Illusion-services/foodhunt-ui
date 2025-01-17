import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/services/models/core/cart.dart';

class CartStoreItem extends StatelessWidget {
  final StoreCart store;
  final VoidCallback onTap;

  const CartStoreItem({
    Key? key,
    required this.store,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store logo
            ClipOval(
              child: Image.asset(
                store.logoUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Store details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bodyTextColor,
                        fontFamily: "JK_Sans"),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${store.itemsCount} items',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.subTitleTextColor,
                        fontFamily: "JK_Sans"),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    store.location,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.subTitleTextColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "JK_Sans"),
                  ),
                ],
              ),
            ),
            // Chevron icon
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.string(
                SvgIcons.chevronRightIcon,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                    AppColors.subTitleTextColor, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
