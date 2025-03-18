import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_bloc.new.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_event.new.dart';
import 'package:food_hunt/screens/app/user/store/bloc/dishes_bloc.dart';
import 'package:food_hunt/screens/app/user/store/bloc/store_bloc.dart';
import 'package:food_hunt/services/models/core/cart.recent.dart';
import 'package:food_hunt/state/app_state/app_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 200 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract storeId from arguments in didChangeDependencies
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final storeId = arguments?['storeId'] as String?;

    // Only fetch if storeId is different or not set yet
    if (storeId != null && storeId != _storeId) {
      _storeId = storeId;
      context.read<UserStoreBloc>().add(FetchUserStoreProfile(storeId));
      context.read<StoreDishesBloc>().add(FetchStoreDishes(storeId));
    }
  }

  Map<String, List<dynamic>> groupDishesByMenu(List<dynamic> dishes) {
    Map<String, List<dynamic>> groupedDishes = {};

    for (var dish in dishes) {
      // Check if 'menu' exists and is not null
      if (dish['menu'] != null && dish['menu'] is Map<String, dynamic>) {
        // Check if 'name' exists in 'menu' and is not null
        String? menuName = dish['menu']['name'];
        if (menuName != null) {
          // Initialize the list if the menuName is not already in the map
          if (!groupedDishes.containsKey(menuName)) {
            groupedDishes[menuName] = [];
          }
          // Add the dish to the corresponding menuName list
          groupedDishes[menuName]!.add(dish);
        } else {
          // Handle dishes with no menu name (optional)
          if (!groupedDishes.containsKey('Uncategorized')) {
            groupedDishes['Uncategorized'] = [];
          }
          groupedDishes['Uncategorized']!.add(dish);
        }
      } else {
        // Handle dishes with no menu (optional)
        if (!groupedDishes.containsKey('Uncategorized')) {
          groupedDishes['Uncategorized'] = [];
        }
        groupedDishes['Uncategorized']!.add(dish);
      }
    }

    return groupedDishes;
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final storeId = arguments?['storeId'] as String;

    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<UserStoreBloc, StoreState>(
          builder: (context, state) {
            if (state is StoreLoading) {
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
            }

            if (state is StoreError) {
              return errorState(
                  context: context,
                  text: state.message,
                  onTap: () {
                    context
                        .read<UserStoreBloc>()
                        .add(FetchUserStoreProfile(storeId));
                  });
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 184,
                  floating: false,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor:
                      _isScrolled ? Colors.white : Colors.transparent,
                  elevation: _isScrolled ? 2 : 0,

                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          state is StoreLoaded
                              ? (state.storeProfile['restaurant']
                                      ?['header_image'] ??
                                  'Store Name Unavailable')
                              : "",
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),

                        // Back icon
                        Positioned(
                          top: 50,
                          left: 20,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: SvgPicture.string(
                                  SvgIcons.arrowLeftIcon,
                                  width: 18,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                      AppColors.bodyTextColor, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Heart icon
                        Positioned(
                          top: 50,
                          right: 60,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: SvgPicture.string(
                                  SvgIcons.heartOutLinedIcon,
                                  width: 14,
                                  height: 14,
                                  colorFilter: ColorFilter.mode(
                                      AppColors.bodyTextColor, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Share icon
                        Positioned(
                          top: 50,
                          right: 20,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: SvgPicture.string(
                                  SvgIcons.shareIcon,
                                  width: 14,
                                  height: 14,
                                  colorFilter: ColorFilter.mode(
                                      AppColors.bodyTextColor, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // AppBar elements when scrolled
                  leading: _isScrolled
                      ? InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: _isScrolled
                                  ? Colors.transparent
                                  : Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: SvgPicture.string(
                                SvgIcons.arrowLeftIcon,
                                width: 18,
                                height: 18,
                                colorFilter: ColorFilter.mode(
                                    AppColors.bodyTextColor, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        )
                      : null,

                  title: _isScrolled
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(
                                state is StoreLoaded
                                    ? (state.storeProfile['restaurant']
                                            ?['profile_image'] ??
                                        'Store Name Unavailable')
                                    : "",
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state is StoreLoaded
                                  ? (state.storeProfile['restaurant']
                                          ?['name'] ??
                                      'Store Name Unavailable')
                                  : "Loading...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.bodyTextColor,
                                fontFamily: "JK_Sans",
                              ),
                            ),
                          ],

                          // Text(
                          //   state is StoreLoaded
                          //       ? (state.storeProfile['restaurant']?['name'] ??
                          //           'Store Name Unavailable')
                          //       : "Loading...",
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w600,
                          //     color: AppColors.bodyTextColor,
                          //     fontFamily: "JK_Sans",
                          //   ),
                          // ),
                        )
                      : null,

                  actions: _isScrolled
                      ? [
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(0xfff2f2f2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: SvgPicture.string(
                                    SvgIcons.heartOutLinedIcon,
                                    width: 12,
                                    height: 12,
                                    colorFilter: ColorFilter.mode(
                                        AppColors.labelTextColor,
                                        BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(0xfff2f2f2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: SvgPicture.string(
                                    SvgIcons.searchIcon,
                                    width: 12,
                                    height: 12,
                                    colorFilter: ColorFilter.mode(
                                        AppColors.labelTextColor,
                                        BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                      : null,
                ), // Scrollable Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                          state is StoreLoaded
                                              ? (state.storeProfile[
                                                          'restaurant']
                                                      ?['profile_image'] ??
                                                  'Store Name Unavailable')
                                              : "",
                                        )),
                                    const SizedBox(width: 8),
                                    Text(
                                      state is StoreLoaded
                                          ? (state.storeProfile['restaurant']
                                                  ?['name'] ??
                                              'Store Name Unavailable')
                                          : "Loading...",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.bodyTextColor,
                                        fontFamily: "JK_Sans",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      state is StoreLoaded
                                          ? (state.storeProfile['restaurant']
                                                  ?['address']['address'] ??
                                              '...')
                                          : "Loading...",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.subTitleTextColor,
                                        fontFamily: "JK_Sans",
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    SvgPicture.string(
                                      SvgIcons.locationIcon,
                                      width: 12,
                                      height: 12,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.primary, BlendMode.srcIn),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                ),
                              ],
                            ),
                            TextButton.icon(
                              iconAlignment: IconAlignment.end,
                              label: Text("Store Info",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                    fontFamily: "JK_Sans",
                                  )),
                              icon: SvgPicture.string(
                                SvgIcons.chevronRightIcon,
                                width: 12,
                                height: 12,
                                colorFilter: ColorFilter.mode(
                                    AppColors.primary, BlendMode.srcIn),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.string(
                                        SvgIcons.starIcon,
                                        width: 14,
                                        height: 14,
                                        colorFilter: ColorFilter.mode(
                                            AppColors.primary, BlendMode.srcIn),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "5.0",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.bodyTextColor,
                                          fontFamily: "JK_Sans",
                                        ),
                                      ),
                                    ]),
                                const SizedBox(height: 4),
                                Text("Reviews",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.subTitleTextColor,
                                      fontFamily: "JK_Sans",
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.string(
                                        SvgIcons.clockIcon,
                                        width: 14,
                                        height: 14,
                                        colorFilter: ColorFilter.mode(
                                            AppColors.primary, BlendMode.srcIn),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "10-20 mins",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.bodyTextColor,
                                          fontFamily: "JK_Sans",
                                        ),
                                      ),
                                    ]),
                                const SizedBox(height: 4),
                                Text("Delivery Time",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.subTitleTextColor,
                                      fontFamily: "JK_Sans",
                                    )),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.string(
                                        SvgIcons.deliveryIcon,
                                        width: 14,
                                        height: 14,
                                        colorFilter: ColorFilter.mode(
                                            AppColors.primary, BlendMode.srcIn),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "$naira $deliveryFee",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.bodyTextColor,
                                          fontFamily: "JK_Sans",
                                        ),
                                      ),
                                    ]),
                                const SizedBox(height: 4),
                                Text("Delivery Fee",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.subTitleTextColor,
                                      fontFamily: "JK_Sans",
                                    )),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // InkWell(
                        //     onTap: () {},
                        //     child: Container(
                        //       padding: EdgeInsets.symmetric(
                        //           vertical: 8, horizontal: 16),
                        //       decoration: BoxDecoration(
                        //         color: AppColors.primary.withOpacity(0.1),
                        //         borderRadius: BorderRadius.circular(100),
                        //       ),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Row(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.center,
                        //               children: [
                        //                 Container(
                        //                     width: 24,
                        //                     height: 24,
                        //                     decoration: BoxDecoration(
                        //                       color: AppColors.primary,
                        //                       borderRadius:
                        //                           BorderRadius.circular(100),
                        //                     ),
                        //                     child: Center(
                        //                       child: SvgPicture.string(
                        //                         SvgIcons.tagIcon,
                        //                         width: 14,
                        //                         height: 14,
                        //                         colorFilter: ColorFilter.mode(
                        //                             Colors.white,
                        //                             BlendMode.srcIn),
                        //                       ),
                        //                     )),
                        //                 const SizedBox(width: 12),
                        //                 Text("Your have available promo",
                        //                     style: TextStyle(
                        //                       fontSize: 12,
                        //                       fontWeight: FontWeight.w500,
                        //                       color: AppColors.bodyTextColor,
                        //                       fontFamily: "JK_Sans",
                        //                     )),
                        //               ]),
                        //           SvgPicture.string(
                        //             SvgIcons.chevronRightIcon,
                        //             width: 14,
                        //             height: 14,
                        //             colorFilter: ColorFilter.mode(
                        //                 AppColors.bodyTextColor,
                        //                 BlendMode.srcIn),
                        //           ),
                        //         ],
                        //       ),
                        //     )),
                        // const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Menu",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.bodyTextColor,
                                  fontFamily: "JK_Sans",
                                )),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Color(0xfff2f2f2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: SvgPicture.string(
                                    SvgIcons.searchIcon,
                                    width: 18,
                                    height: 18,
                                    colorFilter: ColorFilter.mode(
                                        AppColors.bodyTextColor,
                                        BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<StoreDishesBloc, StoreDishesState>(
                          builder: (context, dishesState) {
                            if (dishesState is StoreDishesLoading) {
                              return Center(
                                child: Theme.of(context).platform ==
                                        TargetPlatform.iOS
                                    ? const CupertinoActivityIndicator(
                                        radius: 12, color: AppColors.primary)
                                    : const SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                            color: AppColors.primary),
                                      ),
                              );
                            }

                            if (dishesState is StoreDishesError) {
                              return Center(
                                child: emptyState(
                                    context, 'Error: ${dishesState.message}',
                                    onTap: () {
                                  context
                                      .read<StoreDishesBloc>()
                                      .add(FetchStoreDishes(storeId));
                                }),
                              );
                            }

                            if (dishesState is StoreDishesLoaded) {
                              print(dishesState.storeDishes);
                              print('state.storeDishes');

                              if (dishesState.storeDishes.isEmpty) {
                                return Container(
                                    height: 300,
                                    child: emptyState(context,
                                        'No dishes available. Check back later'));
                              }

                              final groupedDishes =
                                  groupDishesByMenu(dishesState.storeDishes);
                              final menuNames = groupedDishes.keys.toList();

                              return DefaultTabController(
                                  length: menuNames.length + 1,
                                  child: SizedBox(
                                    height: MediaQuery.of(context)
                                        .size
                                        .height, // Ensures it has a height
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ButtonsTabBar(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          buttonMargin:
                                              EdgeInsets.only(right: 20),
                                          backgroundColor: AppColors.primary,
                                          unselectedBackgroundColor:
                                              AppColors.grayBackground,
                                          radius: 100,
                                          borderWidth: 0,
                                          borderColor: Colors.transparent,
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "JK_Sans",
                                          ),
                                          unselectedLabelStyle: TextStyle(
                                            color: AppColors.grayTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "JK_Sans",
                                          ),
                                          onTap: (idx) {
                                            print(idx);
                                          },
                                          tabs: [
                                            Tab(text: 'All'),
                                            ...menuNames
                                                .map((menuName) =>
                                                    Tab(text: menuName))
                                                .toList(),
                                          ],
                                        ),
                                        Expanded(
                                          child: TabBarView(
                                            children: [
                                              _buildAllDishes(
                                                  dishesState.storeDishes,
                                                  state),
                                              ...menuNames
                                                  .map((menuName) =>
                                                      _buildMenuSection(
                                                          menuName,
                                                          groupedDishes[
                                                              menuName]!,
                                                          state))
                                                  .toList(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            }

                            return Center(
                              child: emptyState(context,
                                  'Something went wrong. Please try again',
                                  onTap: () {
                                context
                                    .read<StoreDishesBloc>()
                                    .add(FetchStoreDishes(storeId));
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

  Widget _buildAllDishes(List<dynamic> dishes, StoreState state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dishes.length,
      itemBuilder: (context, index) {
        final dish = dishes[index];
        return GestureDetector(
            onTap: () {
              _showDishBottomSheet(dish, state);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          dish['dish_image'] ??
                              'https://via.placeholder.com/100x80',
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 80,
                              color: Colors.grey[300],
                              child: Icon(Icons.broken_image,
                                  color: Colors.grey[600]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dish['name'],
                          style: TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.bodyTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dish['description'],
                          style: TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 12.0,
                            color: AppColors.subTitleTextColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$naira ${dish['price']}",
                          style: TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bodyTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildMenuSection(
      String title, List<dynamic> dishes, StoreState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  final dish = dishes[index];

                  return GestureDetector(
                      onTap: () {
                        _showDishBottomSheet(dish, state);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    dish['dish_image'] ??
                                        'https://via.placeholder.com/100x80',
                                    width: 100,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.broken_image,
                                            color: Colors.grey[600]),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dish['name'],
                                    style: TextStyle(
                                      fontFamily: 'JK_Sans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.bodyTextColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dish['description'],
                                    style: TextStyle(
                                      fontFamily: 'JK_Sans',
                                      fontSize: 12.0,
                                      color: AppColors.subTitleTextColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "$naira ${dish['price']}",
                                    style: TextStyle(
                                      fontFamily: 'JK_Sans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bodyTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                })),

        const SizedBox(height: 16), // Optional spacing below the items
      ],
    );
  }

  void _showDishBottomSheet(Map<String, dynamic> dish, StoreState state) {
    int quantity = 1;

    final double price = dish['price'] ?? 0;

    final dynamic storeName = state is StoreLoaded
        ? (state.storeProfile['restaurant']?['name'] ?? '')
        : "";

    final dynamic storeId = state is StoreLoaded
        ? (state.storeProfile['restaurant']?['id'] ?? '')
        : "";

    final dynamic storeLogo = state is StoreLoaded
        ? (state.storeProfile['restaurant']?['profile_image'] ?? '')
        : "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section with close button
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        child: Image.network(
                          dish['dish_image'],
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Dish details section
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dish['name'] ?? "...",
                            style: TextStyle(
                              fontFamily: 'JK_Sans',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bodyTextColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "$naira ${price}",
                            style: TextStyle(
                              fontFamily: 'Gabarito',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Description",
                            style: TextStyle(
                              fontFamily: 'JK_Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bodyTextColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            dish['description'],
                            // "Lorem ipsum dolor sit amet consectetur. Arcu sit mi aliquam nunc justo. Urna ut congue nulla quis id facilisis. Lorem ipsum dolor sit amet consectetur. Arcu sit mi aliquam nunc justo.",
                            style: TextStyle(
                              fontFamily: 'JK_Sans',
                              fontSize: 14,
                              color: AppColors.subTitleTextColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom section with quantity and add to cart
                  Container(
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
                    child: Row(
                      children: [
                        // Quantity control
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grayBorderColor,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (quantity > 1) {
                                    setState(() => quantity--);
                                  }
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: quantity > 1
                                      ? AppColors.bodyTextColor
                                      : AppColors.grayBorderColor,
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                  fontFamily: 'JK_Sans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.bodyTextColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() => quantity++);
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: AppColors.bodyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        // Add to cart button
                        Expanded(
                          child: AppButton(
                            label:
                                "Add to Cart - ${naira}${(price * quantity).toStringAsFixed(2)}",
                            onPressed: () {
                              final foodItem = FoodItem(
                                  id: dish['id'].toString(),
                                  name: dish['name'],
                                  dishImage: dish['dish_image'],
                                  description: dish['description'],
                                  price: price,
                                  storeId: storeId.toString(),
                                  storeName: storeName.toString(),
                                  storeLogo: storeLogo.toString());

                              // Add to cart
                              context
                                  .read<CartBloc>()
                                  .add(AddToCart(foodItem, quantity: quantity));

                              // Optional: Show added to cart snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  actionOverflowThreshold: 0.3,
                                  content: Row(
                                    children: [
                                      Icon(Icons.shopping_cart,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        // '${quantity}x ${foodItem.name} added to cart',
                                        'Added to cart',

                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: Font.jkSans.fontName),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppColors.appGreen,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 6,
                                  duration: Duration(seconds: 4),
                                  action: SnackBarAction(
                                    label: 'View Cart',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      // Navigator.pop(context);
                                      Future.delayed(Duration(seconds: 2), () {
                                        // Navigator.pop(context);
                                        context
                                            .read<TabBloc>()
                                            .add(OnCartTabEvent());
                                      });
                                    },
                                  ),
                                ),
                              );

                              Navigator.pop(context);
                            },
                            color: AppColors.primary,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
