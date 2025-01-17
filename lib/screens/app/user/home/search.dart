import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/states/empty_state.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/home/bloc/restaurants_bloc.dart';
import 'package:food_hunt/screens/app/user/home/widgets/featured_stores.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;
  List<String> searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    context.read<RestaurantsBloc>().add(FetchRestaurants());
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    searchHistory.insert(0, query);
    searchHistory = searchHistory.toSet().toList(); // Remove duplicates
    await prefs.setStringList('recent_searches', searchHistory);
    setState(() {});
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      _saveSearch(query);
      context.read<SearchBloc>().add(SearchItem(query));
      setState(() {
        _showResults = true;
      });
    }
  }

  Widget _buildCustomPill(String text, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
              color: const Color(0XFFF2F2F2),
              borderRadius: BorderRadius.circular(27)),
          child: Text(
            text,
            style: const TextStyle(
                color: Color(0xFF696969),
                fontFamily: 'JK_Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gabarito',
                  color: Color(0xFF333333))),
        ),
        Wrap(
          children: items
              .map((item) =>
                  _buildCustomPill(item, onTap: () => _onSearchSubmitted(item)))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendedStores() {
    return BlocBuilder<RestaurantsBloc, RestaurantsState>(
      builder: (context, state) {
        if (state is RestaurantsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RestaurantsLoaded) {
          final stores = state.stores['featured_restaurants'] as List<dynamic>;
          if (stores.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended Stores',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return _buildStoreCard(store);
                  },
                ),
              ),
            ],
          );
        } else if (state is RestaurantsError) {
          return const SizedBox.shrink();
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is Searching) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchComplete) {
          final results = state.items;
          if (results.isEmpty) {
            return emptyState(
                context, "No items found, try searching another keyword");
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return _buildStoreCard(result);
            },
          );
        } else if (state is SearchFailure) {
          return errorState(
              context: context,
              text: state.message,
              onTap: () {
                context
                    .read<SearchBloc>()
                    .add(SearchItem(_searchController.text));
              });
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStoreCard(dynamic store) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    12.0), // Ensures the image itself has rounded corners
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.grayBorderColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(
                        12.0), // Matches the border radius of the image
                  ),
                  child: Image.network(
                    store['header_image'] ?? '',
                    height: 150.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150.0,
                        width: double.infinity,
                        color: AppColors.grayBackground,
                        child: const Icon(
                          Icons.image,
                          size: 32,
                          color: AppColors.subTitleTextColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromRGBO(255, 255, 255, 0.2),
                    ),
                    child: Center(
                      child: SvgPicture.string(
                        SvgIcons.heartOutLinedIcon,
                        width: 11,
                        height: 11,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(42.0),
                child: Image.network(
                  store['profile_image'] ?? '',
                  width: 32.0,
                  height: 32.0,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      radius: 16.0,
                      backgroundColor: AppColors.grayBackground,
                      child: SvgPicture.string(
                        SvgIcons.profileIcon,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          AppColors.subTitleTextColor,
                          BlendMode.srcIn,
                        ),
                        // color: AppColors.subTitleTextColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store['name'] ?? '...',
                      style: const TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bodyTextColor,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      store['category'] ?? '...',
                      style: const TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grayTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _showResults ? _buildSearchResults() : _buildSearchSuggestions(),
      ),
    );
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
          title: Row(
            children: [
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
              const SizedBox(width: 12),
              Expanded(
                  child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  enabled: true,
                  onSubmitted: _onSearchSubmitted,
                  style: TextStyle(
                    fontFamily: Font.jkSans.fontName,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                    color: AppColors.bodyTextColor,
                  ),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search for stores or items',
                    hintStyle: TextStyle(
                      color: AppColors.unActiveTab,
                      fontFamily: Font.jkSans.fontName,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: SvgPicture.string(
                        SvgIcons.searchIcon,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF9CA3AF), BlendMode.srcIn),
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },

                      child: SvgPicture.string(
                        SvgIcons.xIcon,
                        width: 12,
                        height: 12,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF9CA3AF), BlendMode.srcIn),
                      ),
                      // onTap: () {},
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchHistory.isNotEmpty)
            _buildSearchSection('Recent Searches', searchHistory),
          const SizedBox(height: 32),
          // _buildRecommendedStores(),
          FeaturedStoresSection(),
        ],
      ),
    );
  }
}
