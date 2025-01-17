import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/screens/app/store/dashboard/bloc/popular_meals_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

class PopularMealsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Meals',
          style: TextStyle(
            fontFamily: 'Gabarito',
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: AppColors.bodyTextColor,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 200,
          child: BlocBuilder<PopularMealsBloc, PopularMealsState>(
            builder: (context, state) {
              if (state is PopularMealsLoading) {
                return _buildLoadingShimmer();
              } else if (state is PopularMealsLoaded) {
                return _buildPopularMealsList(state.popularMeals);
              } else if (state is PopularMealsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                    ),
                  ),
                );
              } else {
                return const Center(child: Text('No meals to display.'));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.grayBackground,
                highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
                child: Container(
                  height: 100.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Shimmer.fromColors(
                baseColor: AppColors.grayBackground,
                highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
                child: Container(
                  height: 14.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Shimmer.fromColors(
                baseColor: AppColors.grayBackground,
                highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
                child: Container(
                  height: 12.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopularMealsList(List<dynamic> popularMeals) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.4),
      padEnds: false,
      itemCount: popularMeals.length,
      itemBuilder: (context, index) {
        final meal = popularMeals[index];

        // Provide safe defaults for null properties.
        final imageUrl = meal['dish_image'] ?? '';
        final name = meal['name'] ?? 'Unknown Meal';
        final price = meal['price'] != null ? '₦${meal['price']}' : 'Price N/A';

        return Container(
          margin: const EdgeInsets.only(right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      imageUrl,
                      height: 100.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 100.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 32,
                          color: Colors.grey,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.bodyTextColor,
                          ),
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          price,
                          style: const TextStyle(
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
        );
      },
    );
  }
}
