import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/mock_data.dart';

class SearchScreenOld extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreenOld> {
  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;

  List<String> searchHistory = [
    'KFC',
    'Asun jollof rice',
    'Chicken republic',
    'Wine bar'
  ];
  List<String> popularSearches = [
    'KFC',
    'Asun jollof rice',
    'Parfait',
    'Sharwama'
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(
        Duration.zero, () => FocusScope.of(context).requestFocus(FocusNode()));
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      _showResults = true;
    });
  }

  Widget _buildCustomPill(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
            color: Color(0XFFF2F2F2), borderRadius: BorderRadius.circular(27)),
        child: Text(
          text,
          style: TextStyle(
              color: Color(0xFF696969),
              fontSize: 12,
              fontFamily: "JK_Sans",
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildCustomFilterPill(String text, bool showChevron) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
              color: Color(0XFFF2F2F2),
              borderRadius: BorderRadius.circular(27)),
          child: InkWell(
              onTap: () {},
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  text,
                  style: TextStyle(
                      color: AppColors.bodyTextColor,
                      fontSize: 12,
                      fontFamily: "JK_Sans",
                      fontWeight: FontWeight.w500),
                ),
                if (showChevron) SizedBox(width: 8),
                if (showChevron)
                  SvgPicture.string(
                    SvgIcons.chevronDownIcon,
                    width: 12,
                    height: 12,
                  )
              ])),
        ));
  }

  Widget _buildSearchSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(title,
              style: TextStyle(
                  fontFamily: "Gabarito",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333))),
        ),
        Wrap(
          children: items.map((item) => _buildCustomPill(item)).toList(),
        ),
      ],
    );
  }

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
                    style: const TextStyle(
                      fontFamily: 'JK_Sans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      color: AppColors.bodyTextColor,
                    ),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search for stores or items',
                      hintStyle: const TextStyle(
                        color: AppColors.unActiveTab,
                        fontFamily: 'JK_Sans',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _showResults ? _buildSearchResults() : _buildSearchSuggestions(),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchSection('Search History', searchHistory),
          const SizedBox(height: 32),
          // _buildSearchSection('Popular Searches', popularSearches),
          // const SizedBox(height: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended Stores',
                    style: TextStyle(
                      fontFamily: 'Gabarito',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.bodyTextColor,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right,
                        size: 16.0, color: AppColors.primary),
                    iconAlignment: IconAlignment.end,
                    label: const Text(
                      'See All',
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                        height: 1.4, // Line height (16.8px)
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Removes padding for alignment
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  padEnds: false,
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];

                    return Container(
                      margin: const EdgeInsets.only(right: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Store Image with Heart Icon Button
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  store.image,
                                  height: 150.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.2)),
                                      child: Center(
                                          child: SvgPicture.string(
                                        SvgIcons.heartOutLinedIcon,
                                        width: 11,
                                        height: 11,
                                      ))),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(42.0),
                                child: Image.asset(
                                  store.logo,
                                  width: 32.0,
                                  height: 32.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8.0),

                              // Store Name, Type, Distance, and Status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store.name, // Replace with store name
                                      style: TextStyle(
                                        fontFamily: 'JK_Sans',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.bodyTextColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          store.type,
                                          style: TextStyle(
                                            fontFamily: 'JK_Sans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.subTitleTextColor,
                                          ),
                                        ),
                                        const Text(
                                          ' • ',
                                          style: TextStyle(
                                            color: AppColors.subTitleTextColor,
                                          ),
                                        ),
                                        Text(
                                          store
                                              .distance, // Replace with distance
                                          style: TextStyle(
                                            fontFamily: 'JK_Sans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.subTitleTextColor,
                                          ),
                                        ),
                                        const Text(
                                          ' • ',
                                          style: TextStyle(
                                            color: AppColors.subTitleTextColor,
                                          ),
                                        ),
                                        Text(
                                          store.status,
                                          style: TextStyle(
                                              fontFamily: 'JK_Sans',
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                              color: store.status == "Open"
                                                  ? AppColors.success
                                                  : AppColors.error),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 6),
                                decoration: BoxDecoration(
                                    color: AppColors.grayBackground,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Row(
                                  children: [
                                    SvgPicture.string(
                                      SvgIcons.starIcon,
                                      width: 12,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 2.0),
                                    Text(
                                      store.rating.toString(),
                                      style: TextStyle(
                                        fontFamily: 'JK_Sans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.subTitleTextColor,
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
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            _buildCustomFilterPill('Sort', true),
            _buildCustomFilterPill('Top rated', false),
            _buildCustomFilterPill('Promo', false),
          ],
        ),
        const SizedBox(height: 24),
        Text('400 results for "KFC"',
            style: TextStyle(
              color: AppColors.bodyTextColor,
              fontSize: 12,
              fontFamily: "JK_Sans",
            )),
        const SizedBox(height: 24),
        Expanded(
          // child: ListView.builder(
          //   itemCount: 10,
          //   itemBuilder: (context, index) => ListTile(
          //     title: Text('Search Result ${index + 1}'),
          //   ),
          // ),
          child: ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores.reversed.toList()[index];
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Image with Heart Icon Button
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            store.image,
                            height: 150.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
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
                                    color: Color.fromRGBO(255, 255, 255, 0.2)),
                                child: Center(
                                    child: SvgPicture.string(
                                  SvgIcons.heartOutLinedIcon,
                                  width: 11,
                                  height: 11,
                                ))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(42.0),
                          child: Image.asset(
                            store.logo,
                            width: 32.0,
                            height: 32.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8.0),

                        // Store Name, Type, Distance, and Status
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                store.name,
                                style: TextStyle(
                                  fontFamily: 'JK_Sans',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.bodyTextColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    store.type,
                                    style: TextStyle(
                                      fontFamily: 'JK_Sans',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.subTitleTextColor,
                                    ),
                                  ),
                                  const Text(
                                    ' • ',
                                    style: TextStyle(
                                      color: AppColors.subTitleTextColor,
                                    ),
                                  ),
                                  Text(
                                    store.distance,
                                    style: TextStyle(
                                      fontFamily: 'JK_Sans',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.subTitleTextColor,
                                    ),
                                  ),
                                  const Text(
                                    ' • ',
                                    style: TextStyle(
                                      color: AppColors.subTitleTextColor,
                                    ),
                                  ),
                                  Text(
                                    store.status,
                                    style: TextStyle(
                                        fontFamily: 'JK_Sans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: store.status == "Open"
                                            ? AppColors.success
                                            : AppColors.error),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 6),
                          decoration: BoxDecoration(
                              color: AppColors.grayBackground,
                              borderRadius: BorderRadius.circular(24)),
                          child: Row(
                            children: [
                              SvgPicture.string(
                                SvgIcons.starIcon,
                                width: 12,
                                height: 12,
                              ),
                              const SizedBox(width: 2.0),
                              Text(
                                store.rating.toString(),
                                style: TextStyle(
                                  fontFamily: 'JK_Sans',
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subTitleTextColor,
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
            },
          ),
        ),
      ],
    );
  }
}
