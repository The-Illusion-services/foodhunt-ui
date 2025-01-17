import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: onRefresh,
              ),
              SliverToBoxAdapter(
                child: child,
              ),
            ],
          )
        : RefreshIndicator(
            color: AppColors.primary,
            onRefresh: onRefresh,
            child: child,
          );
  }
}
