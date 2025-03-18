import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/user/home/bloc/address_bloc.dart';
import 'package:food_hunt/services/models/core/address.dart';
import 'package:shimmer/shimmer.dart';

class SavedAddressesScreen extends ConsumerWidget {
  SavedAddressesScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  "Saved Addresses",
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
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.addAddressScreen);
              },
              icon: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
              ),
              label: Text(
                "Add Address",
                style: TextStyle(
                  fontFamily: 'JK_Sans',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<UserAddressBloc, UserAddressState>(
                builder: (context, state) {
              if (state is UserAddressLoading) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Shimmer.fromColors(
                        baseColor: AppColors.grayBackground,
                        highlightColor:
                            AppColors.grayBorderColor.withOpacity(0.2),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 120,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 40),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (state is UserAddressLoaded && state.addresses.isEmpty) {
                return Expanded(
                  child: emptyState(context, "No addresses found, add one now!",
                      onTap: () {
                    context.read<UserAddressBloc>().add(FetchUserAddress());
                  }, btnText: "Reload"),
                );
              }

              if (state is UserAddressLoaded && state.addresses.isNotEmpty) {
                final addresses = state.addresses;
                return Expanded(
                    child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    context.read<UserAddressBloc>().add(FetchUserAddress());
                  },
                  child: ListView.builder(
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final isPrimary = address.primary;
                      final label = address.label;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Color(0xFFF2F2F2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: SvgPicture.string(
                                SvgIcons.locationIcon,
                                colorFilter: ColorFilter.mode(
                                    AppColors.bodyTextColor, BlendMode.srcIn),
                                width: 15,
                                height: 16,
                              )),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          address.address,
                                          style: TextStyle(
                                            fontFamily: 'JK_Sans',
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.bodyTextColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(children: [
                                    if (label != null)
                                      Text(
                                        label,
                                        style: TextStyle(
                                          fontFamily: 'JK_Sans',
                                          fontSize: 12.0,
                                          color: AppColors.subTitleTextColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (isPrimary)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Primary",
                                          style: TextStyle(
                                            fontFamily: 'JK_Sans',
                                            fontSize: 10.0,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                  ])
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.string(SvgIcons.ellipsesIcon,
                                  colorFilter: ColorFilter.mode(
                                      AppColors.grayTextColor,
                                      BlendMode.srcIn)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ));
              }

              if (state is UserAddressError) {
                return Expanded(
                  child: errorState(
                    context: context,
                    text: state.message,
                    onTap: () {
                      context.read<UserAddressBloc>().add(FetchUserAddress());
                    },
                  ),
                );
              }

              return SizedBox.shrink();
            })
          ],
        ),
      ),
    );
  }
}
