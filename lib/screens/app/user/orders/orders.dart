import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
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
                  ? _buildOngoingOrders()
                  : _buildHistoryOrders(),
            ),
          ],
        ),
      ),
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
            "Orders",
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
          "Ongoing",
          style: TextStyle(
            fontFamily: "JK_Sans",
            color: _selectedTab == 0 ? Colors.white : AppColors.unActiveTab,
            fontWeight: _selectedTab == 0 ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        1: Text(
          "History",
          style: TextStyle(
            fontFamily: "JK_Sans",
            color: _selectedTab == 1 ? Colors.white : AppColors.unActiveTab,
            fontWeight: _selectedTab == 1 ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
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

  Widget _buildOngoingOrders() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(AppAssets.storeLogoSB),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Star Bucks",
                              style: TextStyle(
                                  fontFamily: "JK_Sans",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.bodyTextColor),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "3 Items | Order ID: #12345",
                              style: TextStyle(
                                  fontFamily: "JK_Sans",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: AppColors.subTitleTextColor),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Placed on: 12:30 PM, 25 Oct",
                              style: TextStyle(
                                  fontFamily: "JK_Sans",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: AppColors.subTitleTextColor),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "$naira 3000",
                        style: TextStyle(
                            fontFamily: "JK_Sans",
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.bodyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: AppColors.grayBorderColor,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  OutlinedAppButton(label: "View Order")
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryOrders() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(AppAssets.storeLogoSB),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Star Bucks",
                              style: TextStyle(
                                  fontFamily: "JK_Sans",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.bodyTextColor),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "3 Items | Order ID: #12345",
                              style: TextStyle(
                                  fontFamily: "JK_Sans",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: AppColors.subTitleTextColor),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Placed on: 12:30 PM, 25 Oct",
                              style: TextStyle(
                                  fontFamily: "JK_Sans",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: AppColors.subTitleTextColor),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "$naira 3000",
                        style: TextStyle(
                            fontFamily: "JK_Sans",
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.bodyTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: AppColors.grayBorderColor,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedAppButton(
                          label: "Review Order",
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          label: "Reorder",
                          onPressed: () {},
                          color: AppColors.primary,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
