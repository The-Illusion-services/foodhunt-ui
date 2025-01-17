import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/store/bloc/store_bloc.dart';

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
    }
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
                        Image.asset(
                          AppAssets.storeHeader,
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
                              color: Colors.white,
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
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Chicken Republic",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bodyTextColor,
                              fontFamily: "JK_Sans",
                            ),
                          ),
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
                                Text(
                                  state is StoreLoaded
                                      ? (state.storeProfile['restaurant']
                                              ?['name'] ??
                                          'Store Name Unavailable')
                                      : "Loading...",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.bodyTextColor,
                                    fontFamily: "JK_Sans",
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.string(
                                      SvgIcons.locationIcon,
                                      width: 12,
                                      height: 12,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.primary, BlendMode.srcIn),
                                    ),
                                    const SizedBox(width: 6),
                                    // Expanded(
                                    //   // Added to prevent overflow
                                    //   child: Text(
                                    //     state is StoreLoaded
                                    //         ? state.storeProfile['address']
                                    //                 ?.toString() ??
                                    //             'Address not available'
                                    //         : "Loading...",
                                    //     style: TextStyle(
                                    //       fontSize: 12,
                                    //       fontWeight: FontWeight.w500,
                                    //       color: AppColors.subTitleTextColor,
                                    //       fontFamily: "JK_Sans",
                                    //     ),
                                    //     overflow: TextOverflow
                                    //         .ellipsis, // Handle long text
                                    //     maxLines:
                                    //         2, // Allow up to 2 lines for address
                                    //   ),
                                    // ),
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
                                        "$naira 4000",
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
                        InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                              child: SvgPicture.string(
                                                SvgIcons.tagIcon,
                                                width: 14,
                                                height: 14,
                                                colorFilter: ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.srcIn),
                                              ),
                                            )),
                                        const SizedBox(width: 12),
                                        Text("Your have available promo",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.bodyTextColor,
                                              fontFamily: "JK_Sans",
                                            )),
                                      ]),
                                  SvgPicture.string(
                                    SvgIcons.chevronRightIcon,
                                    width: 14,
                                    height: 14,
                                    colorFilter: ColorFilter.mode(
                                        AppColors.bodyTextColor,
                                        BlendMode.srcIn),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 32),
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Wrap(
                                spacing: 4,
                                children: [
                                  _buildFilterChip("All", true),
                                  _buildFilterChip("Chicken", false),
                                  _buildFilterChip("Rice and Spaghetti", false),
                                  _buildFilterChip("Desserts", false),
                                  _buildFilterChip("Drinks", false),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildMenuSection("Chicken"),
                        _buildMenuSection("Rice and Spaghetti"),
                        _buildMenuSection("Beverages"),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

  Widget _buildFilterChip(String label, bool _isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FilterChip(
        showCheckmark: false,
        label: Text(
          label,
          style: TextStyle(
              color: _isSelected ? Colors.white : AppColors.subTitleTextColor,
              fontSize: 12,
              fontWeight: _isSelected ? FontWeight.bold : FontWeight.w500,
              fontFamily: "JK_Sans"),
        ),
        backgroundColor: AppColors.grayBackground,
        selectedColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        selected: _isSelected,
        onSelected: (bool selected) {
          setState(() {
            _isSelected = selected;
          });
        },
      ),
    );
  }

  Widget _buildMenuSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: "JK_Sans",
            color: AppColors.bodyTextColor,
          ),
        ),
        const SizedBox(height: 8), // Optional spacing below the title
        Column(
          children: List.generate(3, (index) {
            // Replace with your item list if dynamic
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          AppAssets.storeImage1,
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
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
                          "Grilled Chicken",
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
                          "Lorem ipsum dolor sit amet consectetur. Arcu sit mi aliquam nunc justo. Urna ut congue nulla quis id facilisis.",
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
                          "$naira 3000",
                          style: TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.bodyTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 16), // Optional spacing below the items
      ],
    );
  }
}
