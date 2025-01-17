import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/mock_data.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';

class StoresAroundYouSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.zero, // Removes padding for alignment
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 400, // Set a specific height for the list view
          child: ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoute.storeScreen, arguments: {
                      'storeId': "1",
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Store Image with Heart Icon Button
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                store.image,
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.2)),
                                    child: Center(
                                        child: SvgPicture.string(
                                      SvgIcons.heartOutLinedIcon,
                                      width: 11,
                                      height: 11,
                                    ))),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(42.0),
                              child: Image.asset(
                                store.logo,
                                width: 32.0,
                                height: 32.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8.0),

                            // Store Name, Type, Distance, and Status
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    store.name, // Replace with store name
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
                                        store.type,
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
                                        store.distance, // Replace with distance
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
                                        store
                                            .status, // Replace with open/closed status
                                        style: TextStyle(
                                            fontFamily: 'JK_Sans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: store.status == "Open"
                                                ? AppColors.success
                                                : AppColors.error),
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
                                  borderRadius: BorderRadius.circular(24)),
                              child: Row(
                                children: [
                                  SvgPicture.string(
                                    SvgIcons.starIcon,
                                    width: 12,
                                    height: 12,
                                  ),
                                  const SizedBox(width: 2.0),
                                  Text(
                                    store.rating.toString(),
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
                  ));
            },
          ),
        ),
      ],
    );
  }
}
