import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/widgets/option_group_selector.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';

class EditOptionsGroupScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<EditOptionsGroupScreen> createState() =>
      _EditOptionsGroupScreenState();
}

class _EditOptionsGroupScreenState
    extends ConsumerState<EditOptionsGroupScreen> {
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  TextEditingController minController = TextEditingController();

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
                  "Create Options Group",
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
            AppInputField(
              label: "Group Name",
              hintText: 'Enter options group name',
              controller: itemDescriptionController,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Group name is required';
                }

                return null;
              },
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
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Selection Limit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'JK_Sans',
                    color: AppColors.bodyTextColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'How many options are customers allowed to choose within this group?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'JK_Sans',
                    color: AppColors.subTitleTextColor,
                  ),
                ),
                SizedBox(height: 11),
                Row(
                  children: [
                    AppInputField(
                      label: "",
                      hintText: 'Minimum',
                      controller: minController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Minimum number is required';
                        }

                        return null;
                      },
                    ),
                    SizedBox(width: 11),
                    AppInputField(
                      label: "",
                      hintText: 'Maximum',
                      controller: maxController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Maximum number is required';
                        }

                        return null;
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 32),
            AppButton(label: "Next"),
            const SizedBox(height: 24),
          ],
        ),
      ))),
    );
  }
}
