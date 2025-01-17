import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';

class CustomSearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoute.searchScreen);
        },
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(26.0),
            ),
            child: TextField(
              enabled: false, // Disable direct input here
              style: const TextStyle(
                fontFamily: 'JK_Sans',
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                height: 1.4,
                color: AppColors.bodyTextColor,
              ),
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: '  Search for stores or items',
                hintStyle: const TextStyle(
                  color: AppColors.unActiveTab,
                  fontFamily: 'JK_Sans',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                prefixIcon: InkWell(
                  child: SvgPicture.string(SvgIcons.searchIcon,
                      width: 16,
                      height: 16,
                      colorFilter:
                          ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn)),
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),

                // suffixIconConstraints: BoxConstraints(
                //   minWidth: 2,
                //   minHeight: 2,
                // ),
                // suffixIcon:
                //     InkWell(child: Icon(Icons.clear, size: 14), onTap: () {})),
                // ),
              ),
            )));
  }
}
