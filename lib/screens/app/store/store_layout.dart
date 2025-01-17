import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/store/dashboard/dashboard.dart';
import 'package:food_hunt/screens/app/store/menu/store_menu.dart';
import 'package:food_hunt/screens/app/store/orders/orders.dart';
import 'package:food_hunt/screens/app/store/profile/profile.dart';
import 'package:food_hunt/screens/app/user/cart/cart.dart';
import 'package:food_hunt/screens/app/user/profile/profile.dart';
import 'package:food_hunt/state/app_state/app_bloc.dart';
import 'package:food_hunt/state/store/store_tab_bloc.dart';

class StoreLayout extends StatefulWidget {
  const StoreLayout({Key? key}) : super(key: key);

  @override
  State<StoreLayout> createState() => _StoreLayoutState();
}

class _StoreLayoutState extends State<StoreLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: const WalletScreenAppbar(),
        bottomNavigationBar: Container(
          height: 72,
          padding: const EdgeInsets.only(
            left: 32,
            right: 32,
            top: 12,
            bottom: 13,
          ),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(8, 8),
              blurRadius: 16,
              color: Color.fromRGBO(18, 18, 18, 0.1),
            )
          ]),
          child: BlocBuilder<StoreTabBloc, StoreTabState>(
              builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bottomNavItem(
                  'Dashboard',
                  context: context,
                  asset: SvgIcons.storeDashboardIcon,
                  active: state is StoreDashboardState ? true : false,
                  onTap: () {
                    context
                        .read<StoreTabBloc>()
                        .add(OnStoreDashboardTabEvent());
                  },
                ),
                bottomNavItem(
                  'Orders',
                  context: context,
                  asset: SvgIcons.cartIcon,
                  active: state is StoreOrdersTabState ? true : false,
                  onTap: () {
                    context.read<StoreTabBloc>().add(OnStoreOrdersTabEvent());
                  },
                ),
                bottomNavItem('Create',
                    context: context,
                    asset: SvgIcons.addIcon,
                    active: state is CartTabState ? true : false, onTap: () {
                  // context.read<StoreTabBloc>().add(OnCartTabEvent());
                  Navigator.pushNamed(context, AppRoute.createNewMenuItem);
                }),
                bottomNavItem(
                  'Menu',
                  context: context,
                  asset: SvgIcons.storeMenuIcon,
                  active: state is StoreMenuTabState ? true : false,
                  onTap: () {
                    context.read<StoreTabBloc>().add(OnStoreMenuTabEvent());
                  },
                ),
                bottomNavItem(
                  'Profile',
                  context: context,
                  asset: SvgIcons.profileIcon,
                  active: state is StoreProfileTabState ? true : false,
                  onTap: () {
                    context.read<StoreTabBloc>().add(OnStoreProfileTabEvent());
                  },
                ),
              ],
            );
          }),
        ),
        body: BlocBuilder<StoreTabBloc, StoreTabState>(builder: (context, st) {
          return Container(
            color: Colors.white,
            child: BlocBuilder<StoreTabBloc, StoreTabState>(
              builder: (ctx, state) {
                if (state is StoreDashboardState) {
                  // context.read<PromotionsBloc>();
                  return StoreDashboard();
                }
                if (state is StoreOrdersTabState) {
                  // return const WalletScreen();
                  return StoreOrdersScreen();
                }
                if (state is CartTabState) {
                  return CartScreen();
                }
                if (state is StoreMenuTabState) {
                  // return const Center();
                  return StoreMenuScreen();
                }
                if (state is StoreProfileTabState) {
                  // context.read<ProfileBloc>().add(OnInitProfileEvent());

                  return StoreProfileScreen();
                }
                return const Text('Nothing to show');
              },
            ),
          );
        }));
  }

  // Widget bottomNavItem(
  //   String title, {
  //   required BuildContext context,
  //   String? asset,
  //   IconData? icon,
  //   bool active = false,
  //   GestureTapCallback? onTap,
  // }) {
  //   return Expanded(
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(10),
  //       splashColor: Theme.of(context).colorScheme.primary,
  //       onTap: onTap,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SizedBox(
  //               width: 20,
  //               child: SvgPicture.string(
  //                 asset!,
  //                 colorFilter: ColorFilter.mode(
  //                     active ? AppColors.primary : AppColors.unActiveTab,
  //                     BlendMode.srcIn),
  //                 semanticsLabel: title,
  //                 width: 20,
  //                 height: 20,
  //               )),
  //           const SizedBox(height: 8),
  //           Text(
  //             '$title ',
  //             style: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               fontFamily: "JK_Sans",
  //               fontSize: 10,
  //               color: active ? AppColors.primary : AppColors.unActiveTab,
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget bottomNavItem(
    String title, {
    required BuildContext context,
    String? asset,
    IconData? icon,
    bool active = false,
    GestureTapCallback? onTap,
  }) {
    if (title == 'Create') {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              // boxShadow: [
              //   BoxShadow(
              //     offset: Offset(0, 4),
              //     blurRadius: 8,
              //     color: Colors.black.withOpacity(0.1),
              //   )
              // ],
            ),
            child: Center(
              child: SvgPicture.string(
                asset!,
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                semanticsLabel: title,
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      );
    }

    // Regular bottom nav items
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Theme.of(context).colorScheme.primary,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              child: SvgPicture.string(
                asset!,
                colorFilter: ColorFilter.mode(
                  active ? AppColors.primary : AppColors.unActiveTab,
                  BlendMode.srcIn,
                ),
                semanticsLabel: title,
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$title ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: "JK_Sans",
                fontSize: 10,
                color: active ? AppColors.primary : AppColors.unActiveTab,
              ),
            )
          ],
        ),
      ),
    );
  }
}
