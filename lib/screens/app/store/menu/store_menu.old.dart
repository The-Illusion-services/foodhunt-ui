import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoreMenuScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<StoreMenuScreen> createState() => _StoreMenuScreenState();
}

class _StoreMenuScreenState extends ConsumerState<StoreMenuScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
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
                    ? _buildMenuOverview()
                    : _selectedTab == 1
                        ? _buildOptionGroup()
                        : _selectedTab == 2
                            ? _buildOptionItem()
                            : SizedBox.shrink()),
          ],
        ),
      ),
      floatingActionButton: _selectedTab == 0
          ? null
          : InkWell(
              onTap: () {
                _selectedTab == 1
                    ? Navigator.pushNamed(context, AppRoute.createOptionGroup)
                    : _selectedTab == 2
                        ? Navigator.pushNamed(
                            context, AppRoute.createOptionItem)
                        : null;
                ;
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: SvgPicture.string(
                    SvgIcons.addIcon,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
          centerTitle: false,
          title: Text(
            "Menu",
            style: TextStyle(
              fontFamily: 'JK_Sans',
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: AppColors.bodyTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabControl() {
    return CustomSlidingSegmentedControl<int>(
      isStretch: true,
      innerPadding: const EdgeInsets.all(4),
      initialValue: _selectedTab,
      children: {
        0: Text(
          "Menu Overview",
          style: TextStyle(
            fontFamily: "JK_Sans",
            color: _selectedTab == 0 ? Colors.white : AppColors.unActiveTab,
            fontWeight: _selectedTab == 0 ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
        1: Text(
          "Option Groups",
          style: TextStyle(
            fontFamily: "JK_Sans",
            color: _selectedTab == 1 ? Colors.white : AppColors.unActiveTab,
            fontWeight: _selectedTab == 1 ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
        2: Text(
          "Options",
          style: TextStyle(
            fontFamily: "JK_Sans",
            color: _selectedTab == 2 ? Colors.white : AppColors.unActiveTab,
            fontWeight: _selectedTab == 2 ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
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
    );
  }

  Widget _buildMenuOverview() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSearch(),
      const SizedBox(
        height: 16,
      ),
      Expanded(
          child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoute.menuItem);
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rice & Spaghetti",
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.bodyTextColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "10 Items",
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.subTitleTextColor),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.string(
                              SvgIcons.chevronRightIcon,
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                  AppColors.subTitleTextColor, BlendMode.srcIn),
                            ),
                          )
                        ],
                      ))));
        },
      ))
    ]);
  }

  Widget _buildOptionGroup() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSearch(),
      const SizedBox(
        height: 16,
      ),
      Expanded(
          child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoute.editOptionGroup);
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sauce",
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.bodyTextColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Stew, Egg Sauce, Ketchup",
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.subTitleTextColor),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.string(
                              SvgIcons.chevronRightIcon,
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                  AppColors.subTitleTextColor, BlendMode.srcIn),
                            ),
                          )
                        ],
                      ))));
        },
      ))
    ]);
  }

  Widget _buildOptionItem() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSearch(),
      const SizedBox(
        height: 16,
      ),
      Expanded(
          child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoute.editOptionItem);
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chicken",
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.bodyTextColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$naira 1,200",
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.subTitleTextColor),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.string(
                              SvgIcons.chevronRightIcon,
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                  AppColors.subTitleTextColor, BlendMode.srcIn),
                            ),
                          )
                        ],
                      ))));
        },
      ))
    ]);
  }

  Widget _buildSearch() {
    return SizedBox(
      height: 36,
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          fillColor: const Color(0xFFF3F3F3),
          filled: true,
          hintText: 'Search',
          hintStyle: const TextStyle(
              fontSize: 14, color: Color(0xFF9CA3AF), fontFamily: "JK_Sans"),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.string(
              SvgIcons.searchIcon,
              width: 16,
              height: 16,
              colorFilter:
                  const ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        ),
      ),
    );
  }
}
