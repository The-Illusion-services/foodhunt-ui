import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/store/profile/children/change_password/bloc/reset_password_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class StoreChangePassword extends StatefulWidget {
  const StoreChangePassword({super.key});

  @override
  _StoreChangePasswordState createState() => _StoreChangePasswordState();
}

class _StoreChangePasswordState extends State<StoreChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final GlobalKey<FormState> _changePasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _resetPasswordBloc = context.read<StoreResetPasswordBloc>();

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
                    "Change Password",
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
        body: BlocConsumer<StoreResetPasswordBloc, StoreResetPasswordState>(
            listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Your password has be updated successfully!',
              icon: SvgPicture.string(
                SvgIcons.successIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
            Navigator.pop(context);
          }

          if (state is ResetPasswordFailure) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.error,
              title: 'Error',
              description: '${state.error}',
              icon: SvgPicture.string(
                SvgIcons.errorIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
          }
        }, builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                        key:
                            _changePasswordFormKey, // Attach the GlobalKey to the Form
                        child: Column(
                          children: [
                            AppInputField(
                              label: "New password",
                              hintText: 'Enter new password',
                              controller: _newPasswordController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (!RegExp(
                                        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$')
                                    .hasMatch(value)) {
                                  return 'Password must be at least 6 characters and contain both letters and numbers';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            AppInputField(
                              label: "Confirm Password",
                              hintText: 'Confirm your password',
                              controller: _confirmNewPasswordController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (!RegExp(
                                        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$')
                                    .hasMatch(value)) {
                                  return 'Password must be at least 6 characters and contain both letters and numbers';
                                }
                                if (_confirmNewPasswordController.text !=
                                    _newPasswordController.text) {
                                  return 'Passwords must match';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            AppInputField(
                              label: "Enter code",
                              hintText:
                                  'Enter the 4-digit otp sent to your mail',
                              keyboardType: TextInputType.number,
                              controller: _otpController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Otp is required';
                                }

                                return null;
                              },
                            ),
                          ],
                        )),
                  ),
                ),
                SafeArea(
                  child: AppButton(
                    label: "Save",
                    isLoading: state is ResetPasswordLoading,
                    isDisabled: state is ResetPasswordLoading,
                    onPressed: () {
                      if (_changePasswordFormKey.currentState!.validate()) {
                        _resetPasswordBloc.add(
                          SubmitResetDetails(
                            code: _otpController.text,
                            newPassword: _newPasswordController.text,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
