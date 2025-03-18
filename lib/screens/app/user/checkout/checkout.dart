import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_bloc.new.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_event.new.dart';
import 'package:food_hunt/screens/app/user/checkout/bloc/checkout_bloc.dart';
import 'package:food_hunt/screens/app/user/home/bloc/address_bloc.dart';
import 'package:food_hunt/screens/app/user/orders/single_order.dart';
import 'package:food_hunt/services/address_service.dart';
import 'package:food_hunt/services/models/core/address.dart';
import 'package:food_hunt/services/models/core/cart.recent.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutPage extends StatefulWidget {
  final StoreCart storeCart;
  final AddressService addressService;

  CheckoutPage({required this.storeCart, required this.addressService});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController deliveryNotesController = TextEditingController();

  bool _isProcessing = false;
  UserAddress? primaryAddress;
  List<UserAddress> addresses = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  // Load addresses from SharedPreferences
  Future<void> _loadAddresses() async {
    final loadedAddresses = await widget.addressService.loadAddresses();
    final primary = await widget.addressService.getPrimaryAddress();

    setState(() {
      addresses = loadedAddresses;
      primaryAddress = primary;
    });
  }

  double get subtotal => widget.storeCart.items.fold(
        0.0,
        (sum, item) => sum + (item.foodItem.price * item.quantity),
      );

  // Calculate service fee (10% of subtotal)
  double get serviceFee => subtotal * serviceFeePercent;

  // Calculate total
  double get total => subtotal + deliveryFee + serviceFee;

  void _processPayment(BuildContext context, UserAddress primaryAddress) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final uniqueTransRef = PayWithPayStack().generateUuidV4();
    final AuthService authService = AuthService();

    try {
      final String? email = await authService.getUserEmail();

      PayWithPayStack().now(
          context: context,
          secretKey: "sk_test_dc3b88f8c5a5a71cfd86e6609f5c8fc2b112d981",
          customerEmail: email!,
          reference: uniqueTransRef,
          currency: "NGN",
          amount: total,
          callbackUrl: "https://khervie00.vercel.app",
          metaData: {},
          transactionCompleted: (paymentData) {
            print(paymentData.toJson());
            context.read<CreateOrderBloc>().add(CreateOrder(
                paymentReference: uniqueTransRef,
                storeId: widget.storeCart.storeId,
                storeName: widget.storeCart.storeName,
                items: widget.storeCart.items,
                subtotal: subtotal,
                deliveryFee: deliveryFee,
                serviceFee: serviceFee,
                total: total,
                deliveryNotes: deliveryNotesController.text,
                addressId: primaryAddress.id));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Payment successful! Creating your order...',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JK_Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );

            debugPrint(paymentData.toString());
          },
          transactionNotCompleted: (reason) {
            debugPrint("==> Transaction failed reason $reason");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Payment failed: $reason',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'JK_Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );

            setState(() {
              _isProcessing = false;
            });
          });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'JK_Sans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateOrderBloc, CreateOrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            setState(() {
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Order created successfully!',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JK_Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
            context
                .read<CartBloc>()
                .add(ClearStoreCart(widget.storeCart.storeId));

            Navigator.pop(context);
            Navigator.pop(context);
            // context.read<TabBloc>().add(OnOrdersTabEvent());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderDetailPage(
                          orderId: state.orderId.toString(),
                        )));
          } else if (state is CreateOrderError) {
            setState(() {
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to create order: ${state.message}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JK_Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummarySection(),
                Divider(height: 1, color: AppColors.grayBorderColor),
                _buildDeliveryDetailsSection(),
                Divider(height: 1, color: AppColors.grayBorderColor),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildSummaryItem(
                          "Subtotal", "${naira}${subtotal.toStringAsFixed(2)}"),
                      SizedBox(height: 8),
                      _buildSummaryItem("Delivery Fee",
                          "${naira}${deliveryFee.toStringAsFixed(2)}"),
                      SizedBox(height: 8),
                      _buildSummaryItem("Service Fee",
                          "${naira}${serviceFee.toStringAsFixed(2)}"),
                      Divider(height: 24, color: AppColors.grayBorderColor),
                      _buildSummaryItem(
                          "Total", "${naira}${total.toStringAsFixed(2)}",
                          isTotal: true),
                    ],
                  ),
                ),
                SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
          title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
            Text("Place order",
                style: TextStyle(
                  fontFamily: 'JK_Sans',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bodyTextColor,
                ))
          ]),
        ),
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            "Order Summary",
            style: TextStyle(
              fontFamily: 'JK_Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.bodyTextColor,
            ),
          ),
          SizedBox(height: 16),

          // Restaurant Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.storeCart.storeLogo),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.storeCart.storeName,
                    style: TextStyle(
                      fontFamily: 'JK_Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bodyTextColor,
                    ),
                  ),
                  Text(
                    "${widget.storeCart.items.length} items",
                    style: TextStyle(
                      fontFamily: 'JK_Sans',
                      fontSize: 14,
                      color: AppColors.subTitleTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),

          // Items List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.storeCart.items.length,
            itemBuilder: (context, index) {
              final item = widget.storeCart.items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(AppAssets.storeImage1),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.foodItem.name,
                            style: TextStyle(
                              fontFamily: 'JK_Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bodyTextColor,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Lorem ipsum dolor sit amet consectetur. Arcu sit mi aliquam nunc justo. Urna ut congue nulla quis id facilisis.",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.subTitleTextColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Quantity: ${item.quantity}",
                            style: TextStyle(
                              fontFamily: 'JK_Sans',
                              fontSize: 12,
                              color: AppColors.subTitleTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "$naira${(item.foodItem.price * item.quantity).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: 'Gabarito',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bodyTextColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Details",
            style: TextStyle(
              fontFamily: 'JK_Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.bodyTextColor,
            ),
          ),
          SizedBox(height: 16),

          // Delivery Address
          FutureBuilder<List<UserAddress>>(
            future: AddressService().loadAddresses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? const CupertinoActivityIndicator(
                          radius: 12,
                          color: AppColors.primary,
                        )
                      : const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                );
              } else if (snapshot.hasError) {
                return Text("Error loading addresses");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                // No addresses found
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grayBorderColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "No addresses found. Please add an address.",
                          style: TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 14,
                            color: AppColors.subTitleTextColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
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
                  ],
                );
              } else {
                // Addresses found
                final addresses = snapshot.data!;
                final primaryAddress = addresses.firstWhere(
                  (address) => address.primary,
                  orElse: () =>
                      addresses.first, // Fallback to the first address
                );

                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grayBorderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            "Delivery Address",
                            style: TextStyle(
                              fontFamily: 'JK_Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bodyTextColor,
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: _showAddressBottomSheet,
                            child: Text(
                              "Change",
                              style: TextStyle(
                                fontFamily: 'JK_Sans',
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        primaryAddress.address,
                        style: TextStyle(
                          fontFamily: 'JK_Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.bodyTextColor,
                        ),
                      ),
                      if (primaryAddress.label != null)
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            primaryAddress.label!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                              fontFamily: Font.jkSans.fontName,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
          ),
          SizedBox(height: 16),

          // Delivery Notes
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grayBorderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Delivery Notes (Optional)",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: deliveryNotesController,
                  decoration: InputDecoration(
                    hintText: "Add notes for rider...",
                    hintStyle: TextStyle(
                      fontFamily: 'JK_Sans',
                      fontSize: 14,
                      color: AppColors.subTitleTextColor,
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'JK_Sans',
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: AppColors.subTitleTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Gabarito',
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.bodyTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return FutureBuilder<List<UserAddress>>(
      future: AddressService().loadAddresses(),
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Handle error state
        if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(20),
            child: AppButton(
              label: "Error loading addresses",
              onPressed: null,
              color: AppColors.primary,
              textColor: Colors.white,
            ),
          );
        }

        // Handle no data or empty addresses
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: EdgeInsets.all(20),
            child: AppButton(
              label: "Add delivery address to continue",
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.addAddressScreen);
              },
              color: AppColors.primary,
              textColor: Colors.white,
            ),
          );
        }

        // Now we can safely access the data
        final addresses = snapshot.data!;
        final primaryAddress = addresses.firstWhere(
          (address) => address.primary,
          orElse: () => addresses.first,
        );

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, -4),
                blurRadius: 16,
              ),
            ],
          ),
          child: AppButton(
            label: "Place Order • ${naira}${total.toStringAsFixed(2)}",
            onPressed: _isProcessing
                ? null
                : () => _processPayment(context, primaryAddress),
            isLoading: _isProcessing,
            color: AppColors.primary,
            textColor: Colors.white,
          ),
        );
      },
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
                          itemCount: 3,
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
                                "No addresses found. Add an address to continue",
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
                              final isPrimary = address.primary;
                              final label = address.label;

                              return GestureDetector(
                                onTap: () async {
                                  // Set the selected address as primary
                                  await widget.addressService
                                      .setPrimaryAddress(address.id.toString());

                                  context
                                      .read<UserAddressBloc>()
                                      .add(FetchUserAddress());
                                  // Close the bottom sheet
                                  Navigator.pop(context);
                                  // Trigger a rebuild of the widget
                                  setState(() {
                                    primaryAddress = address;
                                  });
                                },
                                child: Padding(
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
                                                fontFamily:
                                                    Font.jkSans.fontName,
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
