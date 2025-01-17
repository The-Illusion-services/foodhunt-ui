import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

class PhoneNumberInput extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Color textColor;
  final Color cursorColor;

  const PhoneNumberInput({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.textColor = AppColors.bodyTextColor,
    this.cursorColor = AppColors.placeHolderTextColor,
  }) : super(key: key);

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  String selectedCountryCode = '+234'; // Default country code
  String selectedCountryFlag = '🇳🇬'; // Default country flag
  bool _hasError = false;

  String? phoneNumber;
  List<Map<String, String>> countries = [
    {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬'},
  ];

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontFamily: 'SF_Pro',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.placeHolderTextColor,
                    height: 1.4,
                  ),
                  hintText: 'Search country',
                ),
                style: TextStyle(
                  fontFamily: 'JK_Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.bodyTextColor,
                  height: 1.4,
                ),
                onChanged: (value) {
                  setState(() {
                    // Filter logic can be added here
                  });
                },
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(
                      countries[index]['flag']!,
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: AppColors.bodyTextColor,
                        height: 1.4,
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          countries[index]['name']!,
                          style: TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.bodyTextColor,
                            height: 1.4,
                          ),
                        ),
                        Text(
                          countries[index]['code']!,
                          style: TextStyle(
                            fontFamily: 'JK_Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subTitleTextColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        selectedCountryCode = countries[index]['code']!;
                        selectedCountryFlag = countries[index]['flag']!;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
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
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showCountryPicker,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grayBorderColor),
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.grayBackground,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 13.0), // Matches TextField padding
                child: Row(
                  children: [
                    Text(
                      selectedCountryFlag,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      selectedCountryCode,
                      style: TextStyle(
                        fontFamily: 'SF_Pro',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.bodyTextColor,
                        height: 1.4,
                      ),
                    ),
                    SvgPicture.string(
                      SvgIcons.chevronDownIcon,
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: TextField(
                controller: widget.controller,
                keyboardType: TextInputType.phone,
                cursorColor: widget.cursorColor,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      _hasError ? Color(0xFFFFE6E6) : AppColors.grayBackground,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                  hintText: widget.hintText,
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
                      color: _hasError
                          ? AppColors.error
                          : AppColors.grayBorderColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _hasError
                          ? AppColors.error
                          : AppColors.grayBorderColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _hasError ? AppColors.error : widget.cursorColor,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'SF_Pro',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: widget.textColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
