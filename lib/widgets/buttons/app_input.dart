import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';

class AppInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color textColor;
  final Color cursorColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;

  const AppInputField(
      {Key? key,
      required this.label,
      required this.hintText,
      required this.controller,
      this.maxLength,
      this.keyboardType = TextInputType.text,
      this.isPassword = false,
      this.onChanged,
      this.validator,
      this.textColor = AppColors.bodyTextColor,
      this.cursorColor = AppColors.placeHolderTextColor,
      this.prefixIcon,
      this.suffixIcon})
      : super(key: key);

  @override
  _AppInputFieldState createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _isObscure = true;
  bool _hasError = false;
  String? _errorMessage;

  void _validateInput(String value) {
    final validationResult = widget.validator?.call(value);
    setState(() {
      _hasError = validationResult != null;
      _errorMessage = validationResult;
    });
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
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _isObscure : false,
          onChanged: (value) {
            widget.onChanged?.call(value);
            _validateInput(value);
          },
          maxLength: widget.maxLength,
          cursorColor: widget.cursorColor,
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
                  color:
                      _hasError ? AppColors.error : AppColors.grayBorderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color:
                      _hasError ? AppColors.error : AppColors.grayBorderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _hasError ? AppColors.error : widget.cursorColor,
                ),
              ),
              suffixIcon: widget.suffixIcon != null
                  ? widget.suffixIcon
                  : widget.isPassword
                      ? IconButton(
                          icon: SvgPicture.string(
                            _isObscure
                                ? SvgIcons.closeEyeIcon
                                : SvgIcons.openEyeIcon,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                                Color(0xFF808080), BlendMode.srcIn),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        )
                      : null,
              prefixIcon: widget.prefixIcon),
          style: TextStyle(
            fontFamily: 'SF_Pro',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: widget.textColor,
          ),
        ),
        if (_hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorMessage ?? '',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: "JK_Sans",
              ),
            ),
          ),
      ],
    );
  }
}

class AppTextArea extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxLines;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color textColor;
  final Color cursorColor;

  const AppTextArea({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLines = 4, // Default textarea with 4 lines
    this.onChanged,
    this.validator,
    this.textColor = AppColors.bodyTextColor,
    this.cursorColor = AppColors.placeHolderTextColor,
  }) : super(key: key);

  @override
  _AppTextAreaState createState() => _AppTextAreaState();
}

class _AppTextAreaState extends State<AppTextArea> {
  bool _hasError = false;
  String? _errorMessage;

  void _validateInput(String value) {
    final validationResult = widget.validator?.call(value);
    setState(() {
      _hasError = validationResult != null;
      _errorMessage = validationResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
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

        // Textarea
        TextField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          onChanged: (value) {
            widget.onChanged?.call(value);
            _validateInput(value);
          },
          cursorColor: widget.cursorColor,
          decoration: InputDecoration(
            filled: true,
            fillColor:
                _hasError ? const Color(0xFFFFE6E6) : AppColors.grayBackground,
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
          ),
          style: TextStyle(
            fontFamily: 'SF_Pro',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: widget.textColor,
          ),
        ),

        // Error Message
        if (_hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _errorMessage ?? '',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: "JK_Sans",
              ),
            ),
          ),
      ],
    );
  }
}
