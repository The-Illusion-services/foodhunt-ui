import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/bloc/fetch_dishes_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_menu_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class StoreMenuScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<StoreMenuScreen> createState() => _StoreMenuScreenState();
}

class _StoreMenuScreenState extends ConsumerState<StoreMenuScreen> {
  int _selectedTab = 0;

  // late final FetchMenuBloc _menuBloc;
  // late final FetchDishBloc _dishesBloc;

  @override
  void initState() {
    super.initState();
    // _menuBloc = FetchMenuBloc();
    // _dishesBloc = FetchDishBloc();
    _loadInitialData();
  }

  void _loadInitialData() {
    // _menuBloc.add(FetchAllMenu());
    // _dishesBloc.add(FetchAllDishes());
  }

  @override
  Widget build(BuildContext context) {
    final _menuBloc = context.read<FetchMenuBloc>();
    final _dishesBloc = context.read<FetchDishBloc>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildTabControl(),
            const SizedBox(height: 24),
            Expanded(
                child: _selectedTab == 0
                    ? _buildMenuOverviewContent(_menuBloc)
                    : _selectedTab == 1
                        ? _buildDishesContent(_dishesBloc)
                        : SizedBox.shrink()),
          ],
        ),
      ),
      floatingActionButton:
          _selectedTab == 0 ? null : _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
          centerTitle: false,
          title: Text(
            "Menu",
            style: TextStyle(
              fontFamily: 'JK_Sans',
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: AppColors.bodyTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabControl() {
    return CustomSlidingSegmentedControl<int>(
      isStretch: true,
      innerPadding: const EdgeInsets.all(4),
      initialValue: _selectedTab,
      children: {
        0: Text(
          "Menu Overview",
          style: TextStyle(
            fontFamily: "JK_Sans",
            color: _selectedTab == 0 ? Colors.white : AppColors.unActiveTab,
            fontWeight: _selectedTab == 0 ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
        1: Text(
          "Dishes",
          style: TextStyle(
            fontFamily: "JK_Sans",
            color: _selectedTab == 1 ? Colors.white : AppColors.unActiveTab,
            fontWeight: _selectedTab == 1 ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      },
      onValueChanged: (value) {
        setState(() {
          _selectedTab = value;
        });
      },
      decoration: BoxDecoration(
        color: Color(0xfff1f2f6),
        borderRadius: BorderRadius.circular(100),
      ),
      thumbDecoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(100),
      ),
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
    );
  }

  Widget _buildMenuOverviewContent(FetchMenuBloc _menuBloc) {
    return BlocBuilder<FetchMenuBloc, FetchMenuState>(
      bloc: _menuBloc,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            _menuBloc.add(RefreshMenu());
          },
          child: _buildMenuStateWidget(state, _menuBloc),
        );
      },
    );
  }

  Widget _buildMenuStateWidget(FetchMenuState state, Bloc _menuBloc) {
    if (state is FetchAllMenuLoading) {
      return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => _buildShimmer(),
      );
    } else if (state is FetchAllMenuSuccess) {
      if (state.menu.isEmpty) {
        return emptyState(context, "No menu categories found",
            btnText: "Reload", onTap: () {
          _menuBloc.add(FetchAllMenu());
        });
      }
      return ListView.builder(
        itemCount: state.menu.length,
        itemBuilder: (context, index) => _buildMenuItem(state.menu[index]),
      );
    } else if (state is FetchAllMenuFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.error,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 16,
                fontFamily: 'JK_Sans',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _menuBloc.add(FetchAllMenu()),
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildMenuItem(item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.viewMenu, arguments: {
          'menuId': item['id'].toString(),
          'name': item['name'],
          'description': item['description'],
          'image': item['menu_image']
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12), // Rounded corners
                child: item['menu_image'] != null
                    ? Image.network(
                        item['menu_image'],
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 64,
                        height: 64,
                        color: AppColors.grayBackground,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.string(
                              SvgIcons.cameraIcon,
                              colorFilter: ColorFilter.mode(
                                  AppColors.subTitleTextColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item['name']}',
                      style: TextStyle(
                        fontFamily: "JK_Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColors.bodyTextColor,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item['description']}",
                      style: TextStyle(
                        fontFamily: "JK_Sans",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.subTitleTextColor,
                      ),
                      softWrap: true,
                      maxLines: 3, // Adjust this based on your design
                      overflow:
                          TextOverflow.ellipsis, // Adds "..." after maxLines
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item['dishes']} dishes", // Display the dish count
                      style: TextStyle(
                        fontFamily: "JK_Sans",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.subTitleTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SvgPicture.string(
                SvgIcons.chevronRightIcon,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  AppColors.subTitleTextColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDishesContent(FetchDishBloc _dishesBloc) {
    return BlocBuilder<FetchDishBloc, FetchDishState>(
      bloc: _dishesBloc,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            // _dishesBloc.add(Re());
          },
          child: _buildDishStateWidget(state, _dishesBloc),
        );
      },
    );
  }

  Widget _buildDishStateWidget(FetchDishState state, Bloc _dishesBloc) {
    if (state is FetchAllDishLoading) {
      return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => _buildShimmer(),
      );
    } else if (state is FetchAllDishSuccess) {
      if (state.dishes.isEmpty) {
        return emptyState(context, "No dishes found", btnText: "Reload",
            onTap: () {
          _dishesBloc.add(FetchAllMenu());
        });
      }
      return ListView.builder(
        itemCount: state.dishes.length,
        itemBuilder: (context, index) => _buildDishItem(state.dishes[index]),
      );
    } else if (state is FetchAllDishFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.error,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 16,
                fontFamily: 'JK_Sans',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _dishesBloc.add(FetchAllDishes()),
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDishItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoute.viewDish,
            arguments: {'dish': item});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grayBorderColor)
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.05),
            //     blurRadius: 10,
            //     offset: const Offset(0, 4),
            //   ),
            // ],
            ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dish Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // Rounded corners
              child: item['dish_image'] != null
                  ? Image.network(
                      item['dish_image'],
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      color: AppColors.grayBackground,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.string(
                            SvgIcons.cameraIcon,
                            colorFilter: ColorFilter.mode(
                                AppColors.subTitleTextColor, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // Dish Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dish Name
                  Text(
                    '${item['name']}',
                    style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.bodyTextColor,
                    ),
                    softWrap: true,
                  ),
                  const SizedBox(height: 4),
                  // Dish Price
                  Text(
                    "$naira${item['price']}",
                    style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.subTitleTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Availability Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color:
                    item['is_available'] ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                item['is_available'] ? "Available" : "Unavailable",
                style: TextStyle(
                  fontFamily: "JK_Sans",
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: item['is_available']
                      ? Colors.green[700]
                      : Colors.red[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDishes() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSearch(),
      const SizedBox(
        height: 16,
      ),
      Expanded(
          child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoute.editOptionGroup);
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sauce",
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.bodyTextColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Stew, Egg Sauce, Ketchup",
                                style: TextStyle(
                                    fontFamily: "JK_Sans",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.subTitleTextColor),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {},
                            child: SvgPicture.string(
                              SvgIcons.chevronRightIcon,
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                  AppColors.subTitleTextColor, BlendMode.srcIn),
                            ),
                          )
                        ],
                      ))));
        },
      ))
    ]);
  }

  Widget _buildSearch() {
    return SizedBox(
      height: 36,
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          fillColor: const Color(0xFFF3F3F3),
          filled: true,
          hintText: 'Search',
          hintStyle: const TextStyle(
              fontSize: 14, color: Color(0xFF9CA3AF), fontFamily: "JK_Sans"),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.string(
              SvgIcons.searchIcon,
              width: 16,
              height: 16,
              colorFilter:
                  const ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return InkWell(
      onTap: () {
        _selectedTab == 1
            ? Navigator.pushNamed(context, AppRoute.createDish)
            : null;
        ;
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: SvgPicture.string(
            SvgIcons.addIcon,
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }
}
