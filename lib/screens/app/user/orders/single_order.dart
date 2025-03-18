import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/orders/bloc/single_order_bloc.dart';
import 'package:food_hunt/services/models/core/orders.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  OrderDetailPage({
    required this.orderId,
  });

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  // Mock data
  final Map<String, bool> orderStatuses = {
    'pending': true,
    'processing': true,
    'delivering': true,
    'completed': false,
    'rejected': false,
  };

  int activeStep = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OrderDetailsBloc>().add(FetchOrder(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(onRefresh: () async {
          // Re-fetch the order details when pulled down
          context.read<OrderDetailsBloc>().add(FetchOrder(widget.orderId));
        }, child: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
            builder: (context, state) {
          if (state is OrderLoading) {
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
          } else if (state is OrderError) {
            return Center(child: errorState(context: context));
          } else if (state is OrderLoaded) {
            final order = state.order;
            int _activeStep = 0;

            switch (order.status) {
              case OrderStatus.pending:
                _activeStep = 0;
                break;
              case OrderStatus.processing:
                _activeStep = 1;
                break;
              case OrderStatus.delivering:
                _activeStep = 2;
                break;
              case OrderStatus.completed:
                _activeStep = 4;
                break;
              default:
            }

            return Stack(
              children: [
                // Map View (using placeholder image)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    AppAssets.map,
                    fit: BoxFit.cover,
                  ),
                ),

                // Bottom Sheet
                DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.3,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Handle bar
                            Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 12),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            // Store Details
                            ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    order.restaurant['image'] ?? ""),
                              ),
                              title: Text('${order.restaurant['name']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bodyTextColor,
                                      fontSize: 14)),
                              subtitle: Text(
                                '${order.itemCount} ${order.itemCount == 1 ? "Item" : "Items"} - Order #${order.id.toString()}',
                                style: TextStyle(
                                    color: AppColors.subTitleTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: Text(
                                  '$naira ${order.totalAmount.toString()}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: "Gabarito")),
                            ),

                            Divider(
                              color: AppColors.grayBorderColor,
                              thickness: 1,
                            ),

                            // Order Status Stepper
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                  height: 100,
                                  child: EasyStepper(
                                    activeStep: _activeStep,
                                    // maxReachedStep: ,
                                    enableStepTapping: false,
                                    finishedStepBackgroundColor:
                                        AppColors.primary,
                                    finishedStepIconColor: Colors.white,
                                    finishedStepBorderType: BorderType.normal,
                                    finishedStepBorderColor: AppColors.primary,
                                    finishedStepTextColor: AppColors.primary,
                                    unreachedStepBorderType: BorderType.normal,
                                    unreachedStepTextColor:
                                        AppColors.subTitleTextColor,
                                    unreachedStepBorderColor:
                                        AppColors.grayBorderColor,
                                    unreachedStepIconColor:
                                        AppColors.subTitleTextColor,
                                    activeStepBackgroundColor:
                                        AppColors.primary,
                                    activeStepBorderColor: AppColors.primary,
                                    activeStepBorderType: BorderType.normal,
                                    // activeStepIconColor: AppColors.primary,
                                    activeStepTextColor: AppColors.primary,
                                    lineStyle: LineStyle(
                                        lineLength: 45,
                                        lineThickness: 3,
                                        lineSpace: 4,
                                        lineType: LineType.dashed,
                                        defaultLineColor:
                                            AppColors.grayBorderColor,
                                        finishedLineColor: AppColors.primary),
                                    borderThickness: 3,
                                    internalPadding: 10,
                                    loadingAnimation:
                                        'assets/lottie/loading_white.json',
                                    stepRadius: 20,
                                    steps: [
                                      EasyStep(
                                        icon: Icon(activeStep > 0
                                            ? CupertinoIcons.checkmark_alt
                                            : CupertinoIcons.cart),
                                        title: 'Processing',
                                      ),
                                      EasyStep(
                                        icon: Icon(activeStep > 1
                                            ? CupertinoIcons.checkmark_alt
                                            : CupertinoIcons.cube_box),
                                        title: 'Preparing',
                                      ),
                                      EasyStep(
                                        icon: Icon(activeStep > 2
                                            ? CupertinoIcons.checkmark_alt
                                            : CupertinoIcons.car_detailed),
                                        title: 'Delivering',
                                      ),
                                      EasyStep(
                                        icon:
                                            Icon(CupertinoIcons.checkmark_seal),
                                        title: 'Completed',
                                      ),
                                    ],

                                    onStepReached: (index) =>
                                        setState(() => activeStep = index),
                                  )),
                            ),

                            Divider(
                              color: AppColors.grayBorderColor,
                              thickness: 1,
                            ),

                            // Courier Details
                            // ListTile(
                            //   leading: CircleAvatar(
                            //     child: Icon(Icons.motorcycle),
                            //   ),
                            //   title: Text('John Doe'),
                            //   subtitle: Text('Courier ID: CD789'),
                            //   trailing: IconButton(
                            //     icon: Icon(Icons.phone),
                            //     onPressed: () {},
                            //   ),
                            // ),

                            // View Details Button
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: AppButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailsFullPage(),
                                    ),
                                  );
                                },
                                label: "View full details",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Back Button
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else
            return SizedBox.shrink();
        })));
  }

  List<Widget> _buildStatusSteps() {
    List<Widget> steps = [];
    int index = 0;

    orderStatuses.forEach((status, isCompleted) {
      if (index > 0) {
        steps.add(
          Expanded(
            child: Container(
              height: 2,
              color: isCompleted ? AppColors.primary : Colors.grey[300],
            ),
          ),
        );
      }

      steps.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? Colors.green : Colors.grey[300],
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

      index++;
    });

    return steps;
  }
}

class OrderDetailsFullPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Store Information
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Store Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/store_logo.png'),
                    ),
                    title: Text('Store Name'),
                    subtitle: Text('123 Store Street'),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Order Information
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    title: Text('Order #123456'),
                    subtitle: Text('Placed on March 15, 2024'),
                    trailing: Text('\$45.99',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Delivery Information
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.motorcycle),
                    ),
                    title: Text('John Doe'),
                    subtitle: Text('Courier ID: CD789'),
                    trailing: IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
