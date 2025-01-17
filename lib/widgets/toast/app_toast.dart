import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';

class ToastWidget {
  static void showToast({
    required BuildContext context,
    required ToastificationType type,
    required String title,
    required String description,
    Alignment alignment = Alignment.topRight,
    Duration autoCloseDuration = const Duration(seconds: 5),
    Duration animationDuration = const Duration(milliseconds: 300),
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    SvgPicture? icon,
    bool showIcon = true,
    bool showProgressBar = true,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    EdgeInsetsGeometry margin =
        const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(12)),
    List<BoxShadow> boxShadow = const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      ),
    ],
    CloseButtonShowType closeButtonShowType = CloseButtonShowType.onHover,
    bool closeOnClick = false,
    bool pauseOnHover = true,
    bool dragToClose = true,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      toastification.show(
        context: context,
        type: type,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: autoCloseDuration,
        title: Text(
          title,
          style: titleStyle ??
              const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "JK_Sans",
                  fontSize: 14),
        ),
        description: Text(
          description,
          style: descriptionStyle ??
              const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: "JK_Sans",
                  fontSize: 14),
        ),
        alignment: alignment,
        animationDuration: animationDuration,
        icon: icon ?? const Icon(Icons.info),
        showIcon: showIcon,
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        showProgressBar: showProgressBar,
        closeButtonShowType: closeButtonShowType,
        closeOnClick: closeOnClick,
        pauseOnHover: pauseOnHover,
        dragToClose: dragToClose,
      );
    });
  }
}
