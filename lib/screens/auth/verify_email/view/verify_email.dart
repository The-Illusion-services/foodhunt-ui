import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/auth/verify_email/bloc/send_otp_bloc.dart';
import 'package:food_hunt/screens/auth/verify_email/bloc/verify_otp_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

class VerifyEmailAddress extends StatefulWidget {
  const VerifyEmailAddress({super.key});

  @override
  _VerifyEmailAddressState createState() => _VerifyEmailAddressState();
}

class _VerifyEmailAddressState extends State<VerifyEmailAddress> {
  final TextEditingController _pinController = TextEditingController();
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
    _pinController.dispose();
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
    _startCountdown();
    context.read<ResendVerifyCodeBloc>().add(ResendCodeRequested());
  }

  void _verifyCode() {
    context
        .read<VerifyCodeBloc>()
        .add(VerifyCodeRequested(_pinController.text));
  }

  void _goToShareLocation() {
    Navigator.pushNamed(context, AppRoute.shareLocationScreen);
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
                controller: _pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                // onCompleted: (pin) {
                //   setState(() => showError = pin != '5555');
                // },
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
            BlocConsumer<ResendVerifyCodeBloc, ResendCodeState>(
              listener: (context, state) {
                if (state is ResendCodeSuccess) {
                  ToastWidget.showToast(
                    context: context,
                    type: ToastificationType.success,
                    title: 'Success',
                    description:
                        'OTP has been sent to your email successfully!',
                    icon: SvgPicture.string(
                      SvgIcons.successIcon,
                      width: 20,
                      height: 20,
                      semanticsLabel: "Success",
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  );
                } else if (state is ResendCodeFailure) {
                  ToastWidget.showToast(
                    context: context,
                    type: ToastificationType.error,
                    title: 'Error',
                    description: '${state.error}',
                    icon: SvgPicture.string(
                      SvgIcons.errorIcon,
                      width: 20,
                      height: 20,
                      semanticsLabel: "Error",
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ResendCodeLoading) {
                  return SizedBox(
                      width: 14,
                      height: 14,
                      child: Theme.of(context).platform == TargetPlatform.iOS
                          ? const CupertinoActivityIndicator(
                              radius: 10,
                              color: AppColors.primary,
                            )
                          : const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ));
                }

                return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                              fontWeight: _canResend
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                              fontFamily: "JK_Sans"),
                        ),
                      )
                    ]);
              },
            ),
            SizedBox(height: 32),
            BlocConsumer<VerifyCodeBloc, VerifyCodeState>(
              listener: (context, state) {
                if (state is VerifyCodeSuccess) {
                  ToastWidget.showToast(
                    context: context,
                    type: ToastificationType.success,
                    title: 'Success',
                    description: 'Email verified successfully!',
                    icon: SvgPicture.string(
                      SvgIcons.successIcon,
                      width: 20,
                      height: 20,
                      semanticsLabel: "Success",
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  );
                  _goToShareLocation();
                } else if (state is VerifyCodeFailure) {
                  ToastWidget.showToast(
                    context: context,
                    type: ToastificationType.error,
                    title: 'Error',
                    description: '${state.error}',
                    icon: SvgPicture.string(
                      SvgIcons.errorIcon,
                      width: 20,
                      height: 20,
                      semanticsLabel: "Error",
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return AppButton(
                  isLoading: state is VerifyCodeLoading,
                  isDisabled: state is VerifyCodeLoading,
                  label: "Confirm",
                  onPressed: _verifyCode,
                );
                // return ElevatedButton(
                //   onPressed: _verifyCode,
                //   child: Text('Verify Code'),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
