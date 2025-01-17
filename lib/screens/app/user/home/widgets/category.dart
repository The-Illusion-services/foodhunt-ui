import 'package:flutter/material.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/services/models/core/category.dart';

class CategoriesSection extends StatelessWidget {
  // Sample category data
  final List<Category> categories = [
    Category('Fast food', AppAssets.fast_foods),
    Category('Pizza', AppAssets.pizza),
    Category('Soup', AppAssets.soup),
    Category('Chinese', AppAssets.chinese),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.bodyTextColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_right,
                      size: 16.0, color: AppColors.primary),
                  iconAlignment: IconAlignment.end,
                  label: const Text(
                    'See All',
                    style: TextStyle(
                      fontFamily: 'JK_Sans',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                      height: 1.4, // Line height (16.8px)
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Removes padding for alignment
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories.map((Category category) {
                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(
                            255,
                            121,
                            22,
                            0.05,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Image.asset(
                          category.asset,
                          width: 40,
                          height: 40,
                        )),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontFamily: 'JK_Sans',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ));
  }
}
