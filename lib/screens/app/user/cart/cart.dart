import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/services/models/core/cart.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/user/cart/widgets/multi_cart_item.dart';

class CartScreen extends ConsumerWidget {
  final List<StoreCart> cartStores = [
    StoreCart(
      logoUrl: AppAssets.storeLogoBK,
      name: 'Burger King',
      itemsCount: 3,
      location: 'Downtown',
    ),
    StoreCart(
      logoUrl: AppAssets.storeLogoKFC,
      name: 'Cold Stone',
      itemsCount: 1,
      location: 'Uptown',
    ),
    StoreCart(
      logoUrl: AppAssets.storeLogoSB,
      name: 'Chicken Republic C',
      itemsCount: 2,
      location: 'Suburb',
    ),
    StoreCart(
      logoUrl: AppAssets.storeLogoCR,
      name: 'Starbucks',
      itemsCount: 2,
      location: 'Suburb',
    ),
  ];

  void _onStoreTap(StoreCart store, BuildContext context) {
    Navigator.of(context).pushNamed(AppRoute.storeCart);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // Height of the AppBar
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x40BEBEBE), // Shadow color with opacity
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
            title: Text("Cart",
                style: TextStyle(
                  fontFamily: 'JK_Sans',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bodyTextColor,
                )),
            actions: [
              InkWell(
                  onTap: () {},
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(252, 53, 58, 0.1),
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                        child: SvgPicture.string(
                      SvgIcons.deleteIcon,
                      width: 16,
                      height: 16,
                      colorFilter:
                          ColorFilter.mode(AppColors.error, BlendMode.srcIn),
                    )),
                  )),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20),
        child: Column(
          children: cartStores.map((store) {
            return CartStoreItem(
              store: store,
              onTap: () => _onStoreTap(store, context),
            );
          }).toList(),
        ),
      ),
    );
  }
}
