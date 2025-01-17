import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

class ReviewsSection extends StatelessWidget {
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
                'Your Ratings & Reviews',
                style: TextStyle(
                  fontFamily: 'JK_Sans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bodyTextColor,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right,
                    size: 16.0, color: AppColors.primary),
                iconAlignment: IconAlignment.end,
                label: const Text(
                  'View reviews',
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 12.0,
                    color: AppColors.primary,
                    height: 1.4,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xffe5e7eb)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '4.7',
                  style: const TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 32.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.bodyTextColor,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SvgPicture.string(SvgIcons.starsIcons),
                    const SizedBox(height: 4.0),
                    Text(
                      '7.6k Ratings',
                      style: const TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.subTitleTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
