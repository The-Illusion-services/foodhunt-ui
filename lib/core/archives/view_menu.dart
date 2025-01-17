import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_menu_dishes_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_single_menu_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:shimmer/shimmer.dart';

class ViewMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final menuId = arguments?['menuId'];
    final name = arguments?['name'] as String;
    final description = arguments?['description'] as String;
    final image = arguments?['image'] as String?;

    context.read<FetchMenuDishesBloc>()..add(FetchMenuDishes(menuId: menuId));

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<FetchSingleMenuBloc>()
            .add(FetchSingleMenu(menuId: menuId));
      },
      child: Scaffold(
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
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: SvgPicture.string(
                            SvgIcons.arrowLeftIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "View Menu",
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.bodyTextColor,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.editMenu,
                            arguments: {
                              'initialName': name,
                              'initialDescription': description,
                              'initialImage': image,
                              'menuId': menuId
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: Font.jkSans.fontName),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: _buildMenuContent(context, image, name, description)),
    );
  }

  Widget _buildMenuShimmer() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.grayBackground,
            highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.grayBorderColor,
            ),
          ),
          const SizedBox(height: 20),
          Shimmer.fromColors(
            baseColor: AppColors.grayBackground,
            highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
            child: Container(
              height: 20,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: AppColors.grayBackground,
            highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
            child: Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: AppColors.grayBackground,
            highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
            child: Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: AppColors.grayBackground,
            highlightColor: AppColors.grayBorderColor.withOpacity(0.2),
            child: Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, BuildContext context, String menuId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.string(
              SvgIcons.errorIcon,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AppButton(
              onPressed: () {
                context
                    .read<FetchSingleMenuBloc>()
                    .add(FetchSingleMenu(menuId: menuId));
              },
              label: 'Retry',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuContent(
      BuildContext context, String? image, String name, String description) {
    final dishesBloc = context.read<FetchMenuDishesBloc>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (image != null && image.isNotEmpty)
            Center(
                child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(image),
              backgroundColor: AppColors.grayBackground,
            ))
          else
            Center(
                child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.grayBackground,
              child: Icon(Icons.fastfood, color: AppColors.grayTextColor),
            )),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bodyTextColor,
                    fontFamily: Font.jkSans.fontName),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.subTitleTextColor,
                    fontFamily: Font.jkSans.fontName),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 30),
          BlocBuilder<FetchMenuDishesBloc, FetchMenuDishesState>(
            bloc: dishesBloc,
            builder: (context, dishState) {
              if (dishState is FetchMenuDishesLoading) {
                return _buildDishesShimmer();
              }

              if (dishState is FetchMenuDishesFailure) {
                return Center(
                  child: Text(
                    'Failed to load dishes.',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              if (dishState is FetchMenuDishesSuccess) {
                if (dishState.dishes.isEmpty) {
                  return Center(
                    child: Text(
                      'No dishes available.',
                      style: TextStyle(
                        color: AppColors.labelTextColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dishState.dishes.length,
                  itemBuilder: (context, index) {
                    final dish = dishState.dishes[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        dish.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.bodyTextColor,
                        ),
                      ),
                      subtitle: Text(
                        dish.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.labelTextColor,
                        ),
                      ),
                      leading: dish.imageUrl != null && dish.imageUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(dish.imageUrl!),
                            )
                          : CircleAvatar(
                              backgroundColor: AppColors.grayBackground,
                              child: Icon(Icons.fastfood,
                                  color: AppColors.grayTextColor),
                            ),
                    );
                  },
                );
              }

              return SizedBox(); // Default state
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDishesShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }
}
