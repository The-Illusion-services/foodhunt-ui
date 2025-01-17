import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';

class StoreOrderDetails extends ConsumerStatefulWidget {
  @override
  ConsumerState<StoreOrderDetails> createState() => _StoreOrderDetailsState();
}

class _StoreOrderDetailsState extends ConsumerState<StoreOrderDetails> {
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
                    "Order Details",
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildOrderInfo(),
                const SizedBox(height: 24),
                _buildOrderCart(),
                const SizedBox(height: 24),
                _buildDeliveryInfo(),
                const SizedBox(height: 24),
                _buildCustomerInstruction(),
                const SizedBox(height: 24),
                _buildStoreOrders(),
                const SizedBox(height: 50),
                AppButton(label: "Confirm Order"),
                const SizedBox(height: 12),
                OutlinedAppButton(label: "Cancel Order"),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ));
  }

  Widget _buildOrderInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "#0939",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.bodyTextColor),
            ),
            const SizedBox(height: 8),
            Text(
              "Nov 2, 2024, 10:12am",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppColors.subTitleTextColor),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsetsDirectional.symmetric(
              vertical: 2, horizontal: 12),
          decoration: BoxDecoration(
              color: Color(0xFFFEF6E7),
              borderRadius: BorderRadius.circular(12)),
          child: Text(
            "Pending",
            style: TextStyle(
                fontFamily: "JK_Sans",
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xff865503)),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCart() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Ordered  Item",
            style: TextStyle(
                fontFamily: "JK_Sans",
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.bodyTextColor),
          ),
          InkWell(
              onTap: () {},
              child: SvgPicture.string(
                SvgIcons.chevronDownIcon,
                colorFilter: ColorFilter.mode(
                    AppColors.subTitleTextColor, BlendMode.srcIn),
                width: 14,
                height: 14,
              )),
        ],
      ),
      const SizedBox(height: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCartItem(),
          const SizedBox(height: 16),
          _buildCartItem()
        ],
      ),
    ]);
  }

  Widget _buildDeliveryInfo() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Delivery Info",
            style: TextStyle(
                fontFamily: "JK_Sans",
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.bodyTextColor),
          ),
          InkWell(
              onTap: () {},
              child: SvgPicture.string(
                SvgIcons.chevronDownIcon,
                colorFilter: ColorFilter.mode(
                    AppColors.subTitleTextColor, BlendMode.srcIn),
                width: 14,
                height: 14,
              )),
        ],
      ),
      const SizedBox(height: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "H-Medix City Centre",
            style: TextStyle(
                fontFamily: "JK_Sans",
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.bodyTextColor),
          ),
          const SizedBox(height: 2),
          Text(
            "Gimiya Street, Abuja",
            style: TextStyle(
                fontFamily: "JK_Sans",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: AppColors.bodyTextColor),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Bruno Andersons",
                style: TextStyle(
                    fontFamily: "JK_Sans",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.bodyTextColor),
              ),
              Text(
                "- 0123456789",
                style: TextStyle(
                    fontFamily: "JK_Sans",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.subTitleTextColor),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  Widget _buildCustomerInstruction() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Customer Instructions",
        style: TextStyle(
            fontFamily: "JK_Sans",
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.bodyTextColor),
      ),
      const SizedBox(height: 12),
      Text(
        "Bruno Andersons - 0123456789",
        style: TextStyle(
            fontFamily: "JK_Sans",
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.subTitleTextColor),
      ),
    ]);
  }

  Widget _buildStoreOrders() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Order Summary",
        style: TextStyle(
            fontFamily: "JK_Sans",
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.bodyTextColor),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sub-total",
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.subTitleTextColor),
                ),
                Text(
                  "$naira 72,000",
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.bodyTextColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery Fee",
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.subTitleTextColor),
                ),
                Text(
                  "$naira 0",
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.bodyTextColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Service Charge",
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.subTitleTextColor),
                ),
                Text(
                  "$naira 0",
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.bodyTextColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.bodyTextColor),
                ),
                Text(
                  "$naira 72,000",
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.bodyTextColor),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildCartItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Grilled Chicken",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.bodyTextColor),
            ),
            Text(
              "$naira 34,500",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.bodyTextColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Stew",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontSize: 12,
                  color: AppColors.bodyTextColor),
            ),
            Text(
              "$naira 300",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontSize: 12,
                  color: AppColors.subTitleTextColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Egg Sauce",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontSize: 12,
                  color: AppColors.bodyTextColor),
            ),
            Text(
              "$naira 500",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontSize: 12,
                  color: AppColors.subTitleTextColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ketchup",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontSize: 12,
                  color: AppColors.bodyTextColor),
            ),
            Text(
              "$naira 200",
              style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontSize: 12,
                  color: AppColors.subTitleTextColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "X1",
          style: TextStyle(
              fontFamily: "JK_Sans",
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.bodyTextColor),
        ),
      ],
    );
  }
}
