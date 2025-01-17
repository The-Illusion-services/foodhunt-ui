import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
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
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: SvgPicture.string(
                        SvgIcons.arrowLeftIcon,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "Favorites",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildTabControl(),
            const SizedBox(height: 24),
            Expanded(
              child: _selectedTab == 0
                  ? _buildFavoriteStores()
                  : _buildFavoriteItems(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabControl() {
    return Container(
      width: double.infinity,
      child: CustomSlidingSegmentedControl<int>(
        isStretch: true,
        innerPadding: const EdgeInsets.all(4),
        initialValue: _selectedTab,
        children: {
          0: Text(
            "Stores",
            style: TextStyle(
              fontFamily: "JK_Sans",
              color: _selectedTab == 0 ? Colors.white : AppColors.unActiveTab,
              fontWeight: _selectedTab == 0 ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
          1: Text(
            "Items",
            style: TextStyle(
                fontFamily: "JK_Sans",
                color: _selectedTab == 1 ? Colors.white : AppColors.unActiveTab,
                fontWeight:
                    _selectedTab == 1 ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14),
          ),
        },
        onValueChanged: (value) {
          setState(() {
            _selectedTab = value;
          });
        },
        decoration: BoxDecoration(
          color: Color(0xfff1f2f6),
          borderRadius: BorderRadius.circular(100),
        ),
        thumbDecoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildFavoriteStores() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(AppAssets.storeLogoBK),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Pizza Hut",
                          style: TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.bodyTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.string(
                          SvgIcons.starIcon,
                          colorFilter: ColorFilter.mode(
                              AppColors.appYellow, BlendMode.srcIn),
                          width: 10,
                          height: 10,
                        ),
                        Text(
                          "4.5", // Rating
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Restaurant",
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 10.0,
                        color: AppColors.subTitleTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Lugbe",
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 12.0,
                        color: AppColors.subTitleTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 32,
                  height: 32,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.03),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.string(
                    SvgIcons.heartFilledIcon,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoriteItems() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      AppAssets.storeImage1,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.string(
                        SvgIcons.heartFilledIcon,
                        width: 10,
                        height: 10,
                        colorFilter:
                            ColorFilter.mode(Colors.red, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Grilled Chicken",
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bodyTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Lorem ipsum dolor sit amet consectetur. Arcu sit mi aliquam nunc justo. Urna ut congue nulla quis id facilisis.",
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 12.0,
                        color: AppColors.subTitleTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$naira 3000",
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bodyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
