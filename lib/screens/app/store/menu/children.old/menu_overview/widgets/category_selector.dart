import 'package:flutter/material.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';

class CategorySelector extends StatefulWidget {
  final Function(String)? onCategorySelected;
  final TextEditingController categoryNameController;
  final TextEditingController controller;
  final Color cursorColor;
  final Color textColor;
  final List<String> categories;
  final Function(String)? onAddCategory;

  const CategorySelector({
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
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  bool _hasError = false;
  String? _selectedCategory;
  bool _isActive = true;

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
                    'Select Category',
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

  void _showAddCategoryBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Create new category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'JK_Sans',
                      color: AppColors.bodyTextColor,
                    ),
                  ),
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
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: AppColors.bodyTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AppInputField(
                label: "Category Name",
                hintText: 'Enter categoryName',
                controller: widget.categoryNameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category is required';
                  }

                  return null;
                },
              ),
              SizedBox(height: 24),
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
              SizedBox(height: 24),
              AppButton(label: "Save Category")
            ],
          ),
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
            hintText: 'Select Category',
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
          onPressed: _showAddCategoryBottomSheet,
          icon: Icon(
            Icons.add,
            size: 18,
            color: AppColors.primary,
          ),
          label: Text(
            'Create new category',
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
