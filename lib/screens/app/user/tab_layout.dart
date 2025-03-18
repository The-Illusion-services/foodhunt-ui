import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/helper.dart';
import 'package:food_hunt/screens/app/user/cart/cart.dart';
import 'package:food_hunt/screens/app/user/cart/cart.new.dart';
import 'package:food_hunt/screens/app/user/home/home_screen.dart';
import 'package:food_hunt/screens/app/user/orders/orders.dart';
import 'package:food_hunt/screens/app/user/profile/profile.dart';
import 'package:food_hunt/state/app_state/app_bloc.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AppScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: BlocBuilder<TabBloc, TabState>(builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bottomNavItem(
                  'Home',
                  context: context,
                  asset: SvgIcons.homeIcon,
                  // asset: AppAssets.ladyBug,
                  active: state is InitialTabState ? true : false,
                  onTap: () {
                    context.read<TabBloc>().add(OnInitialTabEvent());
                  },
                ),
                bottomNavItem(
                  'Discovery',
                  context: context,
                  asset: SvgIcons.discoveryIcon,
                  active: state is DiscoveryTabState ? true : false,
                  onTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showInfoDialog(
                        "Coming soon",
                        "We are working on this feature, please check back later!",
                        context,
                      );
                    });
                  },
                ),
                bottomNavItem('Cart',
                    context: context,
                    asset: SvgIcons.cartIcon,
                    active: state is CartTabState ? true : false, onTap: () {
                  context.read<TabBloc>().add(OnCartTabEvent());
                }),
                bottomNavItem(
                  'Order',
                  context: context,
                  asset: SvgIcons.ordersIcon,
                  active: state is OrdersTabState ? true : false,
                  onTap: () {
                    context.read<TabBloc>().add(OnOrdersTabEvent());
                  },
                ),
                bottomNavItem(
                  'Profile',
                  context: context,
                  asset: SvgIcons.profileIcon,
                  active: state is ProfileTabState ? true : false,
                  onTap: () {
                    context.read<TabBloc>().add(OnProfileTabEvent());
                  },
                ),
              ],
            );
          }),
        ),
        body: BlocBuilder<TabBloc, TabState>(builder: (context, st) {
          return Container(
            color: Colors.white,
            child: BlocBuilder<TabBloc, TabState>(
              builder: (ctx, state) {
                if (state is InitialTabState) {
                  // context.read<PromotionsBloc>();
                  return HomeScreen();
                }
                if (state is DiscoveryTabState) {}
                if (state is CartTabState) {
                  // return CartScreen();
                  return CartOverviewScreen();
                }
                if (state is OrdersTabState) {
                  // return const Center();
                  return OrdersScreen();
                }
                if (state is ProfileTabState) {
                  // context.read<ProfileBloc>().add(OnInitProfileEvent());

                  return ProfileScreen();
                }
                return const Text('Nothing to show');
              },
            ),
          );
        }));
  }

  Widget bottomNavItem(
    String title, {
    required BuildContext context,
    String? asset,
    IconData? icon,
    bool active = false,
    GestureTapCallback? onTap,
  }) {
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
                      BlendMode.srcIn),
                  semanticsLabel: title,
                )),
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
