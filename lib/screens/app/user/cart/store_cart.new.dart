// screens/store_cart_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_bloc.new.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_event.new.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_state.new.dart';
import 'package:food_hunt/screens/app/user/checkout/checkout.dart';
import 'package:food_hunt/services/address_service.dart';
import 'package:food_hunt/services/models/core/cart.recent.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';

class StoreCartScreen extends StatelessWidget {
  final StoreCart storeCart;

  const StoreCartScreen({Key? key, required this.storeCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(
                        child: SvgPicture.string(
                      SvgIcons.arrowLeftIcon,
                      width: 20,
                      height: 20,
                    )),
                  )),
              const SizedBox(width: 16),
              Text(storeCart.storeName ?? "...",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ))
            ]),
            actions: [
              InkWell(
                  onTap: () {
                    _showClearStoreCartDialog(context);
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
      body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
        if (state is CartLoaded) {
          final currentStoreCart = state.storeCarts.firstWhere(
            (store) => store.storeId == storeCart.storeId,
            orElse: () => StoreCart(
              storeId: storeCart.storeId,
              storeName: storeCart.storeName,
              storeLogo: storeCart.storeLogo,
              items: [],
            ),
          );

          if (currentStoreCart.items.isEmpty) {
            return Center(
              child: emptyState(context, 'Your cart is empty'),
            );
          }

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(top: 24.0), // Add horizontal padding and top margin
              child: ListView.builder(
                itemCount: currentStoreCart.items.length,
                itemBuilder: (context, index) {
                  final cartItem = currentStoreCart.items[index];
                  return Dismissible(
                    key: Key(cartItem.foodItem.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    onDismissed: (_) {
                      context
                          .read<CartBloc>()
                          .add(RemoveFromCart(cartItem.foodItem.id));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            cartItem.foodItem.dishImage ?? "",
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartItem.foodItem.name,
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.bodyTextColor),
                              ),
                              // const SizedBox(height: 4),
                              Text(cartItem.foodItem.description ?? '',
                                  // "Lorem ipsum dolor sit amet consectetur. Arcu sit mi aliquam nunc justo. Urna ut congue nulla quis id facilisis.",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.subTitleTextColor),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(
                                '$naira${cartItem.foodItem.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.bodyTextColor),
                              ),
                            ],
                          ),
                        ),
                        // Quantity adjuster
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: AppColors.grayTextColor,
                              ),
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  context.read<CartBloc>().add(
                                      DecrementQuantity(cartItem.foodItem.id));
                                } else {
                                  context.read<CartBloc>().add(
                                      RemoveFromCart(cartItem.foodItem.id));
                                }
                              },
                            ),
                            Text(cartItem.quantity.toString()),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: AppColors.grayTextColor,
                              ),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                      AddToCart(
                                        FoodItem(
                                            id: cartItem.foodItem.id,
                                            name: cartItem.foodItem.name,
                                            price: cartItem.foodItem.price,
                                            storeId: cartItem.foodItem.storeId,
                                            storeName:
                                                cartItem.foodItem.storeName,
                                            storeLogo:
                                                cartItem.foodItem.storeLogo,
                                            dishImage:
                                                cartItem.foodItem.dishImage,
                                            description:
                                                cartItem.foodItem.description),
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ));
        }
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
      }),
      bottomNavigationBar: _buildCheckoutButton(context),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartLoaded) {
        // Find the current store cart in the updated state
        final currentStoreCart = state.storeCarts.firstWhere(
          (store) => store.storeId == storeCart.storeId,
          orElse: () => StoreCart(
            storeId: storeCart.storeId,
            storeName: storeCart.storeName,
            storeLogo: storeCart.storeLogo,
            items: [],
          ),
        );

        // Calculate the total price for the store cart
        final totalPrice = currentStoreCart.items.fold(
          0.0,
          (sum, item) => sum + (item.foodItem.price * item.quantity),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
          child: SizedBox(
              width: double.infinity,
              child: AppButton(
                  isDisabled: currentStoreCart.items.isEmpty,
                  onPressed: currentStoreCart.items.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(
                                storeCart: currentStoreCart,
                                addressService: AddressService(),
                              ),
                            ),
                          );
                        },
                  label: 'Checkout - $naira${totalPrice.toStringAsFixed(2)}')),
        );
      } else
        return SizedBox.shrink();
    });
  }

  void _showClearStoreCartDialog(BuildContext context) {
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      // Use CupertinoAlertDialog for iOS
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(
            'Clear cart for this store',
            style: TextStyle(fontFamily: Font.jkSans.fontName),
          ),
          content: Text(
            'Are you sure you want to clear the cart for ${storeCart.storeName}?',
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
                context.read<CartBloc>().add(ClearStoreCart(storeCart.storeId));
                Navigator.pop(context);
              },
              isDestructiveAction: true,
              child: Text(
                'Yes, clear',
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
            'Clear cart for this store',
            style: TextStyle(fontFamily: Font.jkSans.fontName),
          ),
          content: Text(
            'Are you sure you want to clear the cart for ${storeCart.storeName}?',
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
                context.read<CartBloc>().add(ClearStoreCart(storeCart.storeId));
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
