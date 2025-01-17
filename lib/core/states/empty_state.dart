import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

Widget emptyState(BuildContext context, String text,
    {Function? onTap, String? btnText, String? iconAsset, double? scale = 2}) {
  return Builder(
    builder: (BuildContext context) {
      return Column(
        children: [
          Expanded(
              child: Center(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                AppAssets.emptyStateJson,
                width: 144,
                height: 144,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: Font.jkSans.fontName,
                    color: AppColors.subTitleTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              if (onTap != null)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: Font.jkSans.fontName,
                        )),
                    onPressed: () {
                      onTap();
                    },
                    child: (iconAsset != null)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                SvgPicture.string(iconAsset),
                                const SizedBox(width: 4),
                                Text(
                                  btnText!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: Font.jkSans.fontName,
                                      fontSize: 14),
                                )
                              ])
                        : Text(
                            btnText!,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: Font.jkSans.fontName,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          )),
            ],
          )))
        ],
      );
    },
  );
}
