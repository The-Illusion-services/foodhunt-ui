import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/user/home/bloc/all_stores_bloc.dart';
import 'package:shimmer/shimmer.dart';

class StoresAroundYouSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllRestaurantsBloc, AllRestaurantsState>(
      builder: (context, state) {
        if (state is AllRestaurantsLoading) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.grayBackground,
                      highlightColor:
                          AppColors.grayBorderColor.withOpacity(0.2),
                      child: Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: AppColors.grayBorderColor,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: AppColors.grayBackground,
                          highlightColor:
                              AppColors.grayBorderColor.withOpacity(0.2),
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: AppColors.grayBackground,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: AppColors.grayBackground,
                                highlightColor:
                                    AppColors.grayBorderColor.withOpacity(0.2),
                                child: Container(
                                  height: 12.0,
                                  width: 80.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Shimmer.fromColors(
                                baseColor: AppColors.grayBackground,
                                highlightColor:
                                    AppColors.grayBorderColor.withOpacity(0.2),
                                child: Container(
                                  height: 10.0,
                                  width: 120.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: AppColors.grayBackground,
                          highlightColor:
                              AppColors.grayBorderColor.withOpacity(0.2),
                          child: Container(
                            width: 50.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is AllRestaurantsError) {
          return Center(
            child: Container(
              width: double.infinity,
              height: 500,
              child: errorState(
                context: context,
                onTap: () {},
                text: state.message,
              ),
            ),
          );
        } else if (state is AllRestaurantsLoaded) {
          final stores = state.stores as List<dynamic>;

          if (stores.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Stores around you',
                    style: TextStyle(
                      fontFamily: 'Gabarito',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.bodyTextColor,
                    ),
                  ),
                  TextButton.icon(
                    iconAlignment: IconAlignment.end,
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right,
                        size: 16.0, color: AppColors.primary),
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
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoute.storeScreen,
                        arguments: {
                          'storeId': "1",
                        },
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  store?['header_image'] ??
                                      "", // Provide a default value
                                  height: 150.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8.0,
                                right: 8.0,
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color.fromRGBO(255, 255, 255, 0.2),
                                    ),
                                    child: Center(
                                      child: SvgPicture.string(
                                        SvgIcons.heartOutLinedIcon,
                                        width: 11,
                                        height: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(42.0),
                                child: Image.network(
                                  store?['profile_image'] ??
                                      "", // Provide a default value
                                  width: 32.0,
                                  height: 32.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store?['name'] ??
                                          "Unknown Store", // Provide a default value
                                      style: TextStyle(
                                        fontFamily: 'JK_Sans',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.bodyTextColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          store?['category'] ??
                                              "Unknown Category", // Provide a default value
                                          style: TextStyle(
                                            fontFamily: 'JK_Sans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.subTitleTextColor,
                                          ),
                                        ),
                                        const Text(
                                          ' • ',
                                          style: TextStyle(
                                            color: AppColors.subTitleTextColor,
                                          ),
                                        ),
                                        Text(
                                          store?['distance'] ??
                                              "0 km", // Provide a default value
                                          style: TextStyle(
                                            fontFamily: 'JK_Sans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.subTitleTextColor,
                                          ),
                                        ),
                                        const Text(
                                          ' • ',
                                          style: TextStyle(
                                            color: AppColors.subTitleTextColor,
                                          ),
                                        ),
                                        Text(
                                          store?['status'] ??
                                              "Closed", // Provide a default value
                                          style: TextStyle(
                                            fontFamily: 'JK_Sans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: store?['status'] == "Open"
                                                ? AppColors.success
                                                : AppColors.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.grayBackground,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.string(
                                      SvgIcons.starIcon,
                                      width: 12,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 2.0),
                                    Text(
                                      "4.2", // Hardcoded rating for now
                                      style: TextStyle(
                                        fontFamily: 'JK_Sans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.subTitleTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
