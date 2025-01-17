import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/widgets/category_selector.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/widgets/option_group_selector.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';

class CreateNewMenuItemScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreateNewMenuItemScreen> createState() =>
      _CreateNewMenuItemScreenState();
}

class _CreateNewMenuItemScreenState
    extends ConsumerState<CreateNewMenuItemScreen> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController basePriceController = TextEditingController();
  bool _isActive = false;

  @override
  Widget build(
    BuildContext context,
  ) {
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
                  "Add New Items",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            CategorySelector(
              controller: TextEditingController(),
              categoryNameController: TextEditingController(),
              cursorColor: AppColors.grayTextColor,
              textColor: Colors.black,
              categories: [
                'Rice & Spaghetti',
                'Chicken',
                'Ice Cream',
                'Pastries'
              ],
              onCategorySelected: (category) {
                print('Selected category: $category');
              },
              onAddCategory: (newCategory) {
                print('New category added: $newCategory');
              },
            ),
            const SizedBox(height: 24),
            AppInputField(
              label: "Item Name",
              hintText: 'Enter item name',
              controller: itemNameController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Item name is required';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            AppInputField(
              label: "Item Description",
              hintText: 'Enter item description',
              controller: itemDescriptionController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Item description is required';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            AppInputField(
              label: "Base Price",
              hintText: 'Enter base price',
              controller: basePriceController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Base price is required';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload photo/video",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 168,
                    decoration: BoxDecoration(
                        color: AppColors.grayBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.grayBorderColor, width: 1.0)),
                    child: Center(
                        child: SizedBox(
                      width: 190,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.string(
                            SvgIcons.thumbnailIcon,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "File types supported: JPG, PNG, GIF, SVG, Max size: 2 MB",
                            style: TextStyle(
                              fontFamily: 'JK_Sans',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: AppColors.unActiveTab,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )),
                  ),
                )
              ],
            ),
            const SizedBox(height: 34),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product Customization",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Offer customers a range of options, highlighting which parts of the product can be customized, added, or removed. ",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.subTitleTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Choose from pre-existing option groups or create new ones tailored to your menu.",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.subTitleTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            OptionGroupSelector(
              controller: TextEditingController(),
              categoryNameController: TextEditingController(),
              cursorColor: AppColors.grayTextColor,
              textColor: Colors.black,
              categories: ['Sauce', 'Chicken', 'Drink'],
              onCategorySelected: (category) {
                print('Selected group: $category');
              },
              onAddCategory: (newCategory) {
                print('New group added: $newCategory');
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Make in Stock",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ),
                ),
                Switch.adaptive(
                  inactiveTrackColor: AppColors.grayBackground,
                  activeTrackColor: AppColors.primary,
                  value: _isActive,
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 34),
            AppButton(label: "Next"),
            const SizedBox(height: 24),
          ],
        ),
      ))),
    );
  }
}
