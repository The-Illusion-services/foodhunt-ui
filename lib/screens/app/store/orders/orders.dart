import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/store/orders/bloc/completed_orders_bloc.dart';
import 'package:food_hunt/screens/app/store/orders/bloc/new_orders_bloc.dart';
import 'package:food_hunt/screens/app/store/orders/bloc/ongoing_orders_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class StoreOrdersScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<StoreOrdersScreen> createState() => _StoreOrdersScreenState();
}

class _StoreOrdersScreenState extends ConsumerState<StoreOrdersScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<NewOrdersBloc>().add(FetchNewOrders());
    context.read<OngoingOrdersBloc>().add(FetchOngoingOrders());
    context.read<CompletedOrdersBloc>().add(FetchCompletedOrders());
  }

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
            Expanded(child: _buildStoreOrders()),
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
        0: _buildTabLabel("New", 0),
        1: _buildTabLabel("Ongoing", 1),
        2: _buildTabLabel("Completed", 2),
      },
      onValueChanged: (value) {
        setState(() {
          _selectedTab = value;
          // Trigger a fetch for the selected tab
          context.read<NewOrdersBloc>().add(FetchNewOrders());
        });
      },
      decoration: BoxDecoration(
        color: const Color(0xfff1f2f6),
        borderRadius: BorderRadius.circular(100),
      ),
      thumbDecoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(100),
      ),
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildTabLabel(String text, int index) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "JK_Sans",
        color: _selectedTab == index ? Colors.white : AppColors.unActiveTab,
        fontWeight: _selectedTab == index ? FontWeight.w600 : FontWeight.w500,
        fontSize: 12,
      ),
    );
  }

  Widget _buildStoreOrders() {
    return BlocBuilder<NewOrdersBloc, NewOrdersState>(
      builder: (context, state) {
        if (state is NewOrdersLoading) {
          return _buildShimmer(context);
        } else if (state is NewOrdersLoaded) {
          return state.newOrders.isEmpty
              ? emptyState(context, "No orders found", btnText: "Reload",
                  onTap: () {
                  context.read<NewOrdersBloc>().add(FetchNewOrders());
                })
              : _buildOrderList(state.newOrders);
        } else if (state is NewOrdersError) {
          return errorState(
              context: context,
              text: state.message,
              onTap: () {
                context.read<NewOrdersBloc>().add(FetchNewOrders());
              });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildOrderList(List<dynamic> orders) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context.read<NewOrdersBloc>().add(FetchNewOrders());
        return Future.value();
      },
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoute.storeOrderDetails);
            },
            child: _buildOrderItem(order),
          );
        },
      ),
    );
  }

  Widget _buildOrderItem(dynamic order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayBorderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(order),
            const SizedBox(height: 14),
            _buildOrderDetails(order),
            const SizedBox(height: 12),
            _buildOrderFooter(order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(dynamic order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Order ID: ${order['id'] ?? 'N/A'}",
          style: TextStyle(
            fontFamily: "JK_Sans",
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: AppColors.subTitleTextColor,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF6E7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            order['status'] ?? 'Pending',
            style: const TextStyle(
              fontFamily: "JK_Sans",
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Color(0xff865503),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(dynamic order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order['name'] ?? 'Unknown',
          style: TextStyle(
            fontFamily: "JK_Sans",
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.bodyTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          order['description'] ?? 'No description available',
          style: TextStyle(
            fontFamily: "JK_Sans",
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.subTitleTextColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildOrderFooter(dynamic order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "₦${order['price'] ?? '0.00'}",
          style: TextStyle(
            fontFamily: "JK_Sans",
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.bodyTextColor,
          ),
        ),
        Text(
          order['timestamp'] ?? '',
          style: TextStyle(
            fontFamily: "JK_Sans",
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: AppColors.subTitleTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Number of placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        baseColor: AppColors.grayBackground,
                        highlightColor:
                            AppColors.grayBorderColor.withOpacity(0.2),
                        child: Container(
                          height: 16,
                          width: 100,
                          decoration: BoxDecoration(
                              color: AppColors.grayTextColor,
                              borderRadius: BorderRadius.circular(6.0)),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: AppColors.grayBackground,
                        highlightColor:
                            AppColors.grayBorderColor.withOpacity(0.2),
                        child: Container(
                          height: 16,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6.0)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Shimmer.fromColors(
                    baseColor: AppColors.grayBackground,
                    highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
                    child: Container(
                      height: 18,
                      width: 150,
                      decoration: BoxDecoration(
                          color: AppColors.grayTextColor,
                          borderRadius: BorderRadius.circular(6.0)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Shimmer.fromColors(
                    baseColor: AppColors.grayBackground,
                    highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
                    child: Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.grayTextColor,
                          borderRadius: BorderRadius.circular(6.0)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Shimmer.fromColors(
                    baseColor: AppColors.grayBackground,
                    highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
                    child: Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.grayTextColor,
                          borderRadius: BorderRadius.circular(6.0)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        baseColor: AppColors.grayBackground,
                        highlightColor:
                            AppColors.grayBorderColor.withOpacity(0.2),
                        child: Container(
                          height: 18,
                          width: 80,
                          decoration: BoxDecoration(
                              color: AppColors.grayTextColor,
                              borderRadius: BorderRadius.circular(6.0)),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: AppColors.grayBackground,
                        highlightColor:
                            AppColors.grayBorderColor.withOpacity(0.2),
                        child: Container(
                          height: 14,
                          width: 100,
                          decoration: BoxDecoration(
                              color: AppColors.grayTextColor,
                              borderRadius: BorderRadius.circular(6.0)),
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

  // Widget _buildStoreOrders() {
  //   return ListView.builder(
  //     itemCount: 3,
  //     itemBuilder: (context, index) {
  //       return GestureDetector(
  //           onTap: () {
  //             Navigator.pushNamed(context, AppRoute.storeOrderDetails);
  //           },
  //           child: Container(
  //             margin: const EdgeInsets.only(bottom: 16.0),
  //             decoration: BoxDecoration(
  //                 border: Border.all(color: AppColors.grayBorderColor),
  //                 borderRadius: BorderRadius.circular(12)),
  //             child: Padding(
  //               padding: const EdgeInsets.all(12.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         "Order ID: #0939",
  //                         style: TextStyle(
  //                             fontFamily: "JK_Sans",
  //                             fontWeight: FontWeight.w500,
  //                             fontSize: 12,
  //                             color: AppColors.subTitleTextColor),
  //                       ),
  //                       Container(
  //                         padding: const EdgeInsetsDirectional.symmetric(
  //                             vertical: 2, horizontal: 12),
  //                         decoration: BoxDecoration(
  //                             color: Color(0xFFFEF6E7),
  //                             borderRadius: BorderRadius.circular(12)),
  //                         child: Text(
  //                           "Pending",
  //                           style: TextStyle(
  //                               fontFamily: "JK_Sans",
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 12,
  //                               color: Color(0xff865503)),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 14),
  //                   Text(
  //                     "Grilled Chicken",
  //                     style: TextStyle(
  //                         fontFamily: "JK_Sans",
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 14,
  //                         color: AppColors.bodyTextColor),
  //                     textAlign: TextAlign.start,
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     "BBQ Mega Meat, BBQ Mega Meat, BBQ Mega Meat, BBQ Mega Meat, BBQ Mega Meat, ",
  //                     style: TextStyle(
  //                         fontFamily: "JK_Sans",
  //                         fontWeight: FontWeight.w400,
  //                         fontSize: 12,
  //                         color: AppColors.subTitleTextColor),
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   const SizedBox(height: 12),
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Qty:",
  //                         style: TextStyle(
  //                             fontFamily: "JK_Sans",
  //                             fontWeight: FontWeight.w500,
  //                             fontSize: 12,
  //                             color: AppColors.bodyTextColor),
  //                       ),
  //                       const SizedBox(width: 2),
  //                       Text(
  //                         "2",
  //                         style: TextStyle(
  //                             fontFamily: "JK_Sans",
  //                             fontWeight: FontWeight.w500,
  //                             fontSize: 12,
  //                             color: AppColors.subTitleTextColor),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         "$naira 16,900",
  //                         style: TextStyle(
  //                             fontFamily: "JK_Sans",
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 16,
  //                             color: AppColors.bodyTextColor),
  //                       ),
  //                       Text(
  //                         "Nov 2, 2024, 10:12am",
  //                         style: TextStyle(
  //                             fontFamily: "JK_Sans",
  //                             fontWeight: FontWeight.w400,
  //                             fontSize: 10,
  //                             color: AppColors.subTitleTextColor),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ));
  //     },
  //   );
  // }
}
