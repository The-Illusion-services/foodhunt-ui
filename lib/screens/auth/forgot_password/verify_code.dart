import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:pinput/pinput.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key});

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final focusNode = FocusNode();
  bool showError = false;

  Timer? _timer;
  int _remainingSeconds = 90;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
    focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _remainingSeconds = 90;
      _canResend = false;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    // Logic to resend the code
    _startCountdown();
  }

  void _goToSetNewPassword() {
    Navigator.pushNamed(context, AppRoute.setNewPasswordScreen);
  }

  @override
  Widget build(BuildContext context) {
    const length = 4;
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = AppColors.grayBackground;
    final defaultPinTheme = PinTheme(
      width: 70,
      height: 64,
      textStyle: TextStyle(
        fontFamily: "JK_Sans",
        fontSize: 20,
        color: AppColors.bodyTextColor,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayBorderColor),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              'Verification Code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "JK_Sans",
                color: AppColors.bodyTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              "You need to enter the 4-digit code we sent to your Email.",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: "JK_Sans",
                color: AppColors.subTitleTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            SizedBox(
              height: 68,
              child: Pinput(
                length: length,
                controller: _verificationCodeController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                onCompleted: (pin) {
                  setState(() => showError = pin != '5555');
                },
                focusedPinTheme: defaultPinTheme.copyWith(
                  height: 70,
                  width: 76,
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: AppColors.grayBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    color: errorColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              TextButton(
                onPressed: _canResend ? _resendCode : null,
                child: Text(
                  _canResend
                      ? 'Resend Code'
                      : 'Resend Code in ${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                      color: _canResend
                          ? AppColors.primary
                          : AppColors.subTitleTextColor,
                      fontSize: 14,
                      fontWeight:
                          _canResend ? FontWeight.bold : FontWeight.w400,
                      fontFamily: "JK_Sans"),
                ),
              )
            ]),
            SizedBox(height: 32),
            AppButton(
              label: "Confirm",
              onPressed: _goToSetNewPassword,
            ),
          ],
        ),
      ),
    );
  }
}
