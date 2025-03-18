import 'package:flutter/material.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:lottie/lottie.dart';

Widget errorState(
    {required BuildContext context,
    String? text,
    Function? onTap,
    String? btnText,
    bool? showText = true}) {
  return Builder(
    builder: (BuildContext context) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                  child: Center(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    AppAssets.errorStateJson,
                    width: 100,
                    height: 125,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 32),
                  if (showText == true)
                    Text("Something went wrong!",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            fontFamily: Font.jkSans.fontName,
                            color: AppColors.bodyTextColor)),
                  if (showText == true)
                    Text(
                      "It's not you, it's us. And we are fixing this right away. Please hold...",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          fontFamily: Font.jkSans.fontName,
                          color: AppColors.subTitleTextColor),
                      textAlign: TextAlign.center,
                    ),
                  if (showText == true)
                    const SizedBox(
                      height: 32,
                    ),
                  AppButton(
                    label: btnText ?? "Try again",
                    onPressed: () {
                      onTap!();
                    },
                  )
                ],
              )))
            ],
          ));
    },
  );
}
