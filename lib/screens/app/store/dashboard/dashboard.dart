import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/store/dashboard/bloc/overview_bloc.dart';
import 'package:food_hunt/screens/app/store/dashboard/widgets/overview.dart';
import 'package:food_hunt/screens/app/store/dashboard/widgets/popular_meals.dart';
import 'package:food_hunt/screens/app/store/dashboard/widgets/ratings.dart';
import 'package:shimmer/shimmer.dart';

class StoreDashboard extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x40BEBEBE),
                offset: Offset(0, 4),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: AssetImage(AppAssets.profilePicture),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 8),
                BlocBuilder<StoreOverviewBloc, StoreOverviewState>(
                  builder: (context, state) {
                    print(state);
                    if (state is StoreOverviewLoading) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: AppColors.grayBackground,
                            highlightColor:
                                AppColors.grayBorderColor.withOpacity(0.2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: 100,
                                height: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Shimmer.fromColors(
                            baseColor: AppColors.grayBackground,
                            highlightColor:
                                AppColors.grayBorderColor.withOpacity(0.2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: 60,
                                height: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is StoreOverviewLoaded) {
                      // Show store name when loaded
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.overviewData['restaurant_name'] ?? '...',
                            style: TextStyle(
                              fontFamily: 'JK_Sans',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: AppColors.bodyTextColor,
                            ),
                          ),
                          Text(
                            "Open",
                            style: TextStyle(
                              fontFamily: 'JK_Sans',
                              fontSize: 12.0,
                              color: AppColors.appGreen,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(); // Default fallback
                    }
                  },
                ),
              ],
            ),
            actions: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                    child: SvgPicture.string(
                  SvgIcons.notificationIcon,
                  width: 20,
                  height: 20,
                )),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                OverviewSection(),
                const SizedBox(height: 32),
                ReviewsSection(),
                const SizedBox(height: 32),
                PopularMealsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
