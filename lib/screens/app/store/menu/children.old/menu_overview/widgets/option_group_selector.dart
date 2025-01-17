import 'package:flutter/material.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';

class OptionGroupSelector extends StatefulWidget {
  final Function(String)? onCategorySelected;
  final TextEditingController categoryNameController;
  final TextEditingController controller;
  final Color cursorColor;
  final Color textColor;
  final List<String> categories;
  final Function(String)? onAddCategory;

  const OptionGroupSelector({
    Key? key,
    this.onCategorySelected,
    required this.categoryNameController,
    required this.controller,
    required this.cursorColor,
    required this.textColor,
    required this.categories,
    this.onAddCategory,
  }) : super(key: key);

  @override
  _OptionGroupSelectorState createState() => _OptionGroupSelectorState();
}

class _OptionGroupSelectorState extends State<OptionGroupSelector> {
  bool _hasError = false;
  String? _selectedCategory;

  void _showCategoriesBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select Option Group',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'JK_Sans',
                      color: AppColors.bodyTextColor,
                    ),
                  ),
                  SizedBox(height: 21),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.categories.length,
                      itemBuilder: (context, index) {
                        final category = widget.categories[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text on the left
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontFamily: 'JK_Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.bodyTextColor,
                                  ),
                                ),
                                // Radio button on the right
                                Radio<String>(
                                  activeColor: AppColors.primary,
                                  value: category,
                                  groupValue: _selectedCategory,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  AppButton(label: "Confirm Selection"),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          readOnly: true,
          onTap: _showCategoriesBottomSheet,
          cursorColor: widget.cursorColor,
          decoration: InputDecoration(
            filled: true,
            fillColor: _hasError ? Color(0xFFFFE6E6) : AppColors.grayBackground,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
            hintText: 'Select option group',
            hintStyle: TextStyle(
              fontFamily: 'SF_Pro',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.placeHolderTextColor,
              height: 1.4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _hasError ? AppColors.error : AppColors.grayBorderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _hasError ? AppColors.error : AppColors.grayBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _hasError ? AppColors.error : widget.cursorColor,
              ),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
          style: TextStyle(
            fontFamily: 'JK_Sans',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.createOptionGroup);
          },
          icon: Icon(
            Icons.add,
            size: 18,
            color: AppColors.primary,
          ),
          label: Text(
            'Create new group',
            style: TextStyle(
                fontFamily: 'JK_Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
