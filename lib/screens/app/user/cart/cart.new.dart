// screens/cart_overview_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_bloc.new.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_event.new.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_state.new.dart';
import 'package:food_hunt/screens/app/user/cart/store_cart.new.dart';

class CartOverviewScreen extends StatelessWidget {
  const CartOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      _showClearCartDialog(context);
                    },
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
        body: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartInitial ||
                  (state is CartLoaded && state.storeCarts.isEmpty)) {
                return Center(
                  child: emptyState(context, 'No items in your cart'),
                );
              }

              if (state is CartLoaded) {
                return ListView.builder(
                  itemCount: state.storeCarts.length,
                  itemBuilder: (context, index) {
                    final store = state.storeCarts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(store.storeLogo ?? ""),
                        radius: 25,
                      ),
                      title: Text(store.storeName),
                      subtitle: Text(
                        '${store.items.length} items',
                        style: TextStyle(
                            color: AppColors.grayTextColor, fontSize: 13),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreCartScreen(storeCart: store),
                          ),
                        );
                      },
                    );
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }

  void _showClearCartDialog(BuildContext context) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      // Use CupertinoAlertDialog for iOS
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            'Clear Cart',
            style: TextStyle(fontFamily: Font.jkSans.fontName),
          ),
          content: Text(
            'Are you sure you want to clear the entire cart?',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.subTitleTextColor,
                fontFamily: Font.jkSans.fontName),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: Font.jkSans.fontName),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                context.read<CartBloc>().add(ClearCart());
                Navigator.pop(context);
              },
              isDestructiveAction: true,
              child: Text(
                'Clear',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: Font.jkSans.fontName),
              ),
            ),
          ],
        ),
      );
    } else {
      // Use AlertDialog for Android and other platforms
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Clear Cart',
            style: TextStyle(fontFamily: Font.jkSans.fontName),
          ),
          content: Text(
            'Are you sure you want to clear the entire cart?',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.subTitleTextColor,
                fontFamily: Font.jkSans.fontName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: Font.jkSans.fontName),
              ),
            ),
            TextButton(
              onPressed: () {
                // context.read<CartBloc>().add(ClearEntireCart());
                context.read<CartBloc>().add(ClearCart());
                Navigator.pop(context);
              },
              child: Text('Clear',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontFamily: Font.jkSans.fontName)),
            ),
          ],
        ),
      );
    }
  }
}
