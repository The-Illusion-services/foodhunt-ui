import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_menu_bloc.dart';

class MenuSelector extends StatefulWidget {
  final Function(String)? onCategorySelected;
  final TextEditingController controller;
  final Color cursorColor;
  final Color textColor;

  const MenuSelector({
    Key? key,
    this.onCategorySelected,
    required this.controller,
    required this.cursorColor,
    required this.textColor,
  }) : super(key: key);

  @override
  _MenuSelectorState createState() => _MenuSelectorState();
}

class _MenuSelectorState extends State<MenuSelector> {
  bool _hasError = false;
  String? _selectedCategory;

  void _showCategoriesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocBuilder<FetchMenuBloc, FetchMenuState>(
          builder: (context, state) {
            if (state is FetchAllMenuLoading) {
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
            } else if (state is FetchAllMenuSuccess) {
              final categories = state.menu; // List of menu objects
              return Container(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Select Menu',
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
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category['id'].toString();
                              });
                              widget.onCategorySelected
                                  ?.call(_selectedCategory!);
                              widget.controller.text = _selectedCategory!;
                              Navigator.pop(context); // Close the bottom sheet
                            },
                            child: Container(
                              padding: EdgeInsets.only(bottom: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category['name'],
                                    style: TextStyle(
                                      fontFamily: 'JK_Sans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.bodyTextColor,
                                    ),
                                  ),
                                  Radio<String>(
                                    activeColor: AppColors.primary,
                                    value: category['id'].toString(),
                                    groupValue: _selectedCategory,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCategory = value;
                                      });
                                      widget.onCategorySelected?.call(value!);
                                      widget.controller.text = value!;
                                      Navigator.pop(
                                          context); // Close the bottom sheet
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Failed to load menus.'));
            }
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
          onTap: () => _showCategoriesBottomSheet(context),
          cursorColor: widget.cursorColor,
          decoration: InputDecoration(
            filled: true,
            fillColor: _hasError ? Color(0xFFFFE6E6) : AppColors.grayBackground,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
            hintText: 'Select menu',
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
      ],
    );
  }
}
