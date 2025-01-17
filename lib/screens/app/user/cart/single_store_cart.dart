import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/services/models/core/cart.dart';
import 'package:food_hunt/screens/app/user/cart/widgets/single_cart_item.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';

class StoreCartPage extends StatefulWidget {
  // final StoreCart store;

  const StoreCartPage({Key? key}) : super(key: key);

  @override
  _StoreCartPageState createState() => _StoreCartPageState();
}

class _StoreCartPageState extends State<StoreCartPage> {
  List<CartItem> cartItems = [
    CartItem(
      imageUrl: 'https://via.placeholder.com/64',
      name: 'BBQ Mega Meat',
      details: 'BBQ Mega Meat, BBQ Mega Meat, BBQ Mega Meat',
      price: 12.99,
    ),
    CartItem(
      imageUrl: 'https://via.placeholder.com/64',
      name: 'Vegan Delight',
      details: 'Vegan Delight with fresh veggies and spices',
      price: 9.99,
    ),
  ];

  List<bool> selectedItems = [false, false]; // Track selected items

  void _onSelectItem(int index) {
    setState(() {
      selectedItems[index] = !selectedItems[index];
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) cartItems[index].quantity--;
    });
  }

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
              Text("Chicken Republic",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ))
            ]),
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
                      SvgIcons.notificationIcon,
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
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Column(
          children: [
            ...cartItems.asMap().entries.map((entry) {
              int index = entry.key;
              CartItem item = entry.value;
              return CartItemWidget(
                item: item,
                isSelected: selectedItems[index],
                onSelected: () => _onSelectItem(index),
                onIncrement: () => _incrementQuantity(index),
                onDecrement: () => _decrementQuantity(index),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 10.0),
        child: SizedBox(
            width: double.infinity, child: AppButton(label: "Checkout")),
      ),
    );
  }
}
