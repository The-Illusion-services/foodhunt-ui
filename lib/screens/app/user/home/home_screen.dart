import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/user/home/bloc/address_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/inputs/custom_search.dart';
import 'package:food_hunt/screens/app/user/home/widgets/category.dart';
import 'package:food_hunt/screens/app/user/home/widgets/new_stores.dart';
import 'package:food_hunt/screens/app/user/home/widgets/around_you.dart';
import 'package:food_hunt/screens/app/user/home/widgets/featured_stores.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  late final addresses;
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    context.read<UserAddressBloc>().add(FetchUserAddress());
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
            title: BlocConsumer<UserAddressBloc, UserAddressState>(
              listener: (context, state) {
                if (state is UserAddressLoaded && state.addresses.isEmpty) {
                  _showAddressBottomSheet();
                }
              },
              builder: (context, state) {
                if (state is UserAddressLoading) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Loading address...",
                        style: TextStyle(
                          fontFamily: 'JK_Sans',
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          color: AppColors.bodyTextColor,
                        ),
                      )
                    ],
                  );
                } else if (state is UserAddressLoaded) {
                  final addresses = state.addresses;
                  if (addresses.isNotEmpty) {
                    final primaryAddress = addresses.firstWhere(
                      (address) => address.primary,
                      orElse: () => addresses.first,
                    );
                    selectedAddress = primaryAddress.address;
                  } else {
                    selectedAddress = "...";
                  }
                } else {
                  selectedAddress = "...";
                }

                return GestureDetector(
                    onTap: _showAddressBottomSheet,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.string(
                            SvgIcons.locationIcon,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivering to",
                                style: TextStyle(
                                  fontFamily: 'JK_Sans',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                selectedAddress ?? "Add Address",
                                style: TextStyle(
                                  fontFamily: 'JK_Sans',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.bodyTextColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.string(
                            SvgIcons.chevronDownIcon,
                            width: 16,
                            height: 15,
                          ),
                        ]));
              },
            ),
            actions: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                    child: SvgPicture.string(
                  SvgIcons.notificationIcon,
                  width: 20,
                  height: 20,
                )),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            CustomSearchField(),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              AppAssets.home_screen_promo,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 16,
            ),
            // Category
            CategoriesSection(),
            const SizedBox(
              height: 16,
            ),
            FeaturedStoresSection(),
            const SizedBox(
              height: 16,
            ),
            NewStoresSection(),
            const SizedBox(
              height: 16,
            ),
            StoresAroundYouSection(),
          ],
        ),
      ))),
    );
  }

  void _showAddressBottomSheet() {
    Future.delayed(Duration(milliseconds: 300), () {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.7,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your addresses",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bodyTextColor,
                          fontFamily: "JK_Sans",
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.grayBackground,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.close,
                              size: 18, color: AppColors.bodyTextColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                  ]),
                  Divider(color: AppColors.grayBorderColor),
                  SizedBox(height: 8),
                  BlocBuilder<UserAddressBloc, UserAddressState>(
                    builder: (context, state) {
                      if (state is UserAddressLoading) {
                        return Expanded(
                            child: ListView.builder(
                          itemCount: 3, // Placeholder shimmer count
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Shimmer.fromColors(
                              baseColor: AppColors.grayBackground,
                              highlightColor:
                                  AppColors.grayBorderColor.withOpacity(0.2),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ));
                      }

                      if (state is UserAddressLoaded &&
                          state.addresses.isEmpty) {
                        return Expanded(
                            child: emptyState(context,
                                "No addresses found. Add an address  to continue",
                                btnText: "Add Address", onTap: () {
                          Navigator.pushNamed(
                              context, AppRoute.addAddressScreen);
                        }));
                      }

                      if (state is UserAddressLoaded &&
                          state.addresses.isNotEmpty) {
                        final addresses = state.addresses;
                        return Expanded(
                          child: ListView.builder(
                            itemCount: addresses.length,
                            itemBuilder: (context, index) {
                              final address = addresses[index];

                              final isPrimary = address.primary ?? false;
                              final label = address.label;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  tileColor: AppColors.grayBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Text(
                                    address.address,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.bodyTextColor,
                                      fontFamily: Font.jkSans.fontName,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (label != null)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primary,
                                              fontFamily: Font.jkSans.fontName,
                                            ),
                                          ),
                                        ),
                                      if (label != null) SizedBox(width: 8),
                                      if (isPrimary)
                                        Icon(
                                          Icons.star,
                                          size: 20,
                                          color: AppColors.primary,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      if (state is UserAddressError) {
                        return Expanded(
                            child: Center(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Something went wrong, please try again",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.bodyTextColor,
                                        fontFamily: Font.jkSans.fontName,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    AppButton(
                                      label: "Try again",
                                      onPressed: () {
                                        context
                                            .read<UserAddressBloc>()
                                            .add(FetchUserAddress());
                                      },
                                    )
                                  ])),
                        ));
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
