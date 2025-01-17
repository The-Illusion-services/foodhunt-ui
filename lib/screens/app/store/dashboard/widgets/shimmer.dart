import 'package:flutter/material.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerCard() {
  return Shimmer.fromColors(
    baseColor: AppColors.grayBackground,
    highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
    child: Container(
      height: 85,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.grayBorderColor, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 12,
              width: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 16,
              width: 150,
              color: Colors.white,
            ),
          ],
        ),
      ),
    ),
  );
}
