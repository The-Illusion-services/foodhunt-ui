import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:shimmer/shimmer.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/home/bloc/restaurants_bloc.dart';

class FeaturedStoresSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsBloc, RestaurantsState>(
      builder: (context, state) {
        if (state is RestaurantsLoading) {
          return SizedBox(
            height: 200,
            child: PageView.builder(
              padEnds: false,
              controller: PageController(viewportFraction: 0.9),
              itemCount: 3,
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
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
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
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
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
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
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
                              borderRadius: BorderRadius.circular(
                                8.0,
                              ),
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
        } else if (state is RestaurantsError) {
          return Center(
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.grayBackground,
                border: Border.all(color: AppColors.grayBorderColor),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    "Failed to load stores. Please try again.",
                    style: TextStyle(
                        fontFamily: Font.jkSans.fontName,
                        fontSize: 14.0,
                        color: AppColors.grayTextColor,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else if (state is RestaurantsLoaded) {
          final stores = state.stores['featured_restaurants'] as List<dynamic>;

          if (stores.isEmpty) {
            return Center(
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.grayBackground,
                  border: Border.all(color: AppColors.grayBorderColor),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.store_mall_directory_outlined,
                        color: AppColors.grayTextColor, size: 40),
                    const SizedBox(height: 8),
                    const Text(
                      "No stores found.",
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 14.0,
                        color: AppColors.bodyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Featured Stores',
                style: TextStyle(
                  fontFamily: 'Gabarito',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: AppColors.bodyTextColor,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 210,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  padEnds: false,
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Ensures the image itself has rounded corners
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.grayBorderColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Matches the border radius of the image
                                  ),
                                  child: Image.network(
                                    store['header_image'] ?? '',
                                    height: 150.0,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 150.0,
                                        width: double.infinity,
                                        color: AppColors.grayBackground,
                                        child: const Icon(
                                          Icons.image,
                                          size: 32,
                                          color: AppColors.subTitleTextColor,
                                        ),
                                      );
                                    },
                                  ),
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
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.2),
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
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(42.0),
                                child: Image.network(
                                  store['profile_image'] ?? '',
                                  width: 32.0,
                                  height: 32.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return CircleAvatar(
                                      radius: 16.0,
                                      backgroundColor: AppColors.grayBackground,
                                      child: SvgPicture.string(
                                        SvgIcons.profileIcon,
                                        width: 16,
                                        height: 16,
                                        colorFilter: ColorFilter.mode(
                                          AppColors.subTitleTextColor,
                                          BlendMode.srcIn,
                                        ),
                                        // color: AppColors.subTitleTextColor,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store['name'] ?? '...',
                                      style: const TextStyle(
                                        fontFamily: 'JK_Sans',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.bodyTextColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      store['category'] ?? '...',
                                      style: const TextStyle(
                                        fontFamily: 'JK_Sans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grayTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        // Initial or Unknown State
        return Container();
      },
    );
  }
}
