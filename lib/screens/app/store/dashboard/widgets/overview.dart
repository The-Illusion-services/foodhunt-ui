import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/store/dashboard/bloc/overview_bloc.dart';
import 'package:shimmer/shimmer.dart';

class OverviewSection extends StatefulWidget {
  const OverviewSection({super.key});

  @override
  State<OverviewSection> createState() => _OverviewSectionState();
}

class _OverviewSectionState extends State<OverviewSection> {
  // String _selectedTimeframe = 'Today';
  // final List<String> _timeframes = [
  //   'Today',
  //   'This Week',
  //   'This Month',
  //   'This Year'
  // ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreOverviewBloc, StoreOverviewState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontFamily: "JK_Sans",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ),
                ),
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(color: AppColors.grayBorderColor),
                //   ),
                //   child: DropdownButtonHideUnderline(
                //     child: DropdownButton<String>(
                //       value: _selectedTimeframe,
                //       icon: const Icon(Icons.keyboard_arrow_down),
                //       isDense: true,
                //       onChanged: (value) {
                //         setState(() {
                //           _selectedTimeframe = value!;
                //         });
                //       },
                //       items: _timeframes.map((timeframe) {
                //         return DropdownMenuItem<String>(
                //           value: timeframe,
                //           child: Text(
                //             timeframe,
                //             style: const TextStyle(
                //               fontFamily: "JK_Sans",
                //               fontSize: 12.0,
                //               fontWeight: FontWeight.w600,
                //               color: AppColors.bodyTextColor,
                //             ),
                //           ),
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: state is StoreOverviewLoading
                        ? _buildShimmerCard()
                        : _buildCard(
                            'Total Orders',
                            state is StoreOverviewLoaded
                                ? (state.overviewData['total_orders']
                                        ?.toString() ??
                                    '0')
                                : '0',
                            context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: state is StoreOverviewLoading
                        ? _buildShimmerCard()
                        : _buildCard(
                            'Average Sales',
                            state is StoreOverviewLoaded
                                ? '₦${(state.overviewData['total_revenue']?.toString() ?? '0')}'
                                : '0',
                            context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: state is StoreOverviewLoading
                        ? _buildShimmerCard()
                        : _buildCard(
                            'Completed Orders',
                            state is StoreOverviewLoaded
                                ? (state.overviewData['completed_orders']
                                        ?.toString() ??
                                    '0')
                                : '0',
                            context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: state is StoreOverviewLoading
                        ? _buildShimmerCard()
                        : _buildCard(
                            'Total Customers',
                            state is StoreOverviewLoaded
                                ? (state.overviewData['total_customers']
                                        ?.toString() ??
                                    '0')
                                : '0',
                            context),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildCard(String title, String value, BuildContext context) {
    return Container(
      height: 85,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.grayBorderColor, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: "JK_Sans",
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: AppColors.subTitleTextColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
                fontFamily: "JK_Sans",
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.bodyTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: AppColors.grayBackground,
      highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
      child: Container(
        height: 85,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.grayBorderColor, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 12,
                width: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 16,
                width: 150,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
