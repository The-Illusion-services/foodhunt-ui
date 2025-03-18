import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/orders/bloc/orders_bloc.dart';
import 'package:food_hunt/screens/app/user/orders/single_order.dart';
import 'package:food_hunt/services/models/core/orders.dart';
import 'package:food_hunt/state/app_state/app_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  @override
  const OrdersScreen({
    Key? key,
  }) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(LoadOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return Center(
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? const CupertinoActivityIndicator(
                      radius: 20,
                      color: AppColors.primary,
                    )
                  : const CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
            );
          }

          if (state is OrdersError) {
            return Center(
                child: errorState(
              context: context,
              text:
                  "Failed to fetch orders.Please try again or contact support",
              onTap: () {
                context.read<OrdersBloc>().add(LoadOrders());
              },
              btnText: 'Try again',
            ));
          }

          if (state is OrdersLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildTabControl(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _selectedTab == 0
                        ? _buildOngoingOrders(state.ongoingOrders)
                        : _buildHistoryOrders(state.historyOrders),
                  ),
                ],
              ),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOngoingOrders(List<Order> orders) {
    if (orders.isEmpty) {
      return emptyState(
        context,
        "No ongoing orders",
        // subtitle:
        //     "You don't have any ongoing orders at the moment. Place an order to get started!",
        btnText: "Browse Restaurants",
        onTap: () {
          context.read<TabBloc>().add(OnInitialTabEvent());
        },
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(
          order: order,
          showReorder: false,
        );
      },
    );
  }

  Widget _buildHistoryOrders(List<Order> orders) {
    if (orders.isEmpty) {
      return emptyState(
        context,
        // "No Order History",
        "You haven't placed any orders yet. Explore our restaurants and place your first order!",
        btnText: "Explore Now",
        onTap: () {
          context.read<TabBloc>().add(OnInitialTabEvent());
        },
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(
          order: order,
          showReorder: true,
        );
      },
    );
  }

  Widget _buildOrderCard({
    required Order order,
    required bool showReorder,
  }) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderDetailPage(
                          orderId: order.id,
                        )));
          },
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
                        backgroundImage:
                            NetworkImage(order.restaurant['image']),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.restaurant['name'],
                              style: TextStyle(
                                fontFamily: "JK_Sans",
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.bodyTextColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${order.itemCount} ${order.itemCount == 1 ? "Item" : "Items"} | Order ID: #${order.id}",
                              style: TextStyle(
                                fontFamily: "JK_Sans",
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppColors.subTitleTextColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Placed on: ${DateFormat('hh:mm a, dd MMM').format(order.placedAt)}",
                              style: TextStyle(
                                fontFamily: "JK_Sans",
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppColors.subTitleTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "$naira ${order.totalAmount}",
                        style: TextStyle(
                          fontFamily: "JK_Sans",
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.bodyTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: AppColors.grayBorderColor,
                    thickness: 1,
                  ),
                  const SizedBox(height: 16),
                  if (showReorder)
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
                            onPressed: () {
                              context
                                  .read<OrdersBloc>()
                                  .add(ReorderPlaced(order.id));
                            },
                            color: AppColors.primary,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox.shrink()
                  // OutlinedAppButton(label: "View Order")
                ],
              ),
            ),
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(56.0),
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return Container(
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
              actions: [
                if (state is OrdersLoaded)
                  IconButton(
                    icon: Icon(Icons.refresh, color: AppColors.bodyTextColor),
                    onPressed: () {
                      context.read<OrdersBloc>().add(RefreshOrders());
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabControl() {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        // Get the count of orders for each tab
        int ongoingCount = 0;
        int historyCount = 0;

        if (state is OrdersLoaded) {
          ongoingCount = state.ongoingOrders.length;
          historyCount = state.historyOrders.length;
        }

        return CustomSlidingSegmentedControl<int>(
          isStretch: true,
          innerPadding: const EdgeInsets.all(4),
          initialValue: _selectedTab,
          children: {
            0: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ongoing",
                  style: TextStyle(
                    fontFamily: "JK_Sans",
                    color: _selectedTab == 0
                        ? Colors.white
                        : AppColors.unActiveTab,
                    fontWeight:
                        _selectedTab == 0 ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (ongoingCount > 0) ...[
                  SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _selectedTab == 0
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ongoingCount.toString(),
                      style: TextStyle(
                        fontFamily: "JK_Sans",
                        color: _selectedTab == 0
                            ? Colors.white
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            1: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "History",
                  style: TextStyle(
                    fontFamily: "JK_Sans",
                    color: _selectedTab == 1
                        ? Colors.white
                        : AppColors.unActiveTab,
                    fontWeight:
                        _selectedTab == 1 ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (historyCount > 0) ...[
                  SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _selectedTab == 1
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      historyCount.toString(),
                      style: TextStyle(
                        fontFamily: "JK_Sans",
                        color: _selectedTab == 1
                            ? Colors.white
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
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
      },
    );
  }
}
