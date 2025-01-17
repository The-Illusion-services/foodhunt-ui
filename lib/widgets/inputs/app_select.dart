import 'package:flutter/material.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

class AppDropdownSheet<T> extends StatefulWidget {
  final String label;
  final String hintText;
  final T? selectedValue;
  final List<T> options;
  final String Function(T) optionLabelBuilder;
  final Function(T) onChanged;
  final Color textColor;
  final Color cursorColor;

  const AppDropdownSheet({
    Key? key,
    required this.label,
    required this.hintText,
    required this.options,
    required this.optionLabelBuilder,
    required this.onChanged,
    this.selectedValue,
    this.textColor = AppColors.bodyTextColor,
    this.cursorColor = AppColors.placeHolderTextColor,
  }) : super(key: key);

  @override
  _AppDropdownSheetState<T> createState() => _AppDropdownSheetState<T>();
}

class _AppDropdownSheetState<T> extends State<AppDropdownSheet<T>> {
  late T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          expand: false,
          builder: (_, controller) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bodyTextColor,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: widget.options.length,
                  itemBuilder: (_, index) {
                    final option = widget.options[index];
                    final isSelected = option == _selectedValue;

                    return ListTile(
                      title: Text(
                        widget.optionLabelBuilder(option),
                        style: TextStyle(
                          fontFamily: 'SF_Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.bodyTextColor,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedValue = option;
                        });
                        widget.onChanged(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
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
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'JK_Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.labelTextColor,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.grayBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.grayBorderColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedValue != null
                      ? widget.optionLabelBuilder(_selectedValue!)
                      : widget.hintText,
                  style: TextStyle(
                    fontFamily: 'SF_Pro',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: _selectedValue != null
                        ? widget.textColor
                        : AppColors.placeHolderTextColor,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.placeHolderTextColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
