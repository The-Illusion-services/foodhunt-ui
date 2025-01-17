import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/auth/create_account/bloc/create_account_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class CreateStoreAccountTypeScreen extends StatefulWidget {
  const CreateStoreAccountTypeScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoreAccountTypeScreen> createState() =>
      _CreateStoreAccountTypeScreenState();
}

class _CreateStoreAccountTypeScreenState
    extends State<CreateStoreAccountTypeScreen> with TickerProviderStateMixin {
  @override
  Widget build(
    BuildContext context,
  ) {
    final _createAccountBloc = context.read<CreateAccountBloc>();

    // final GlobalKey<FormState> _createAccountFormKey = GlobalKey<FormState>();
    // TextEditingController _userNameController = TextEditingController();
    TextEditingController _firstNameController = TextEditingController();
    TextEditingController _lastNameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    void _goToLogin() async {
      Navigator.pushNamed(context, AppRoute.loginScreen);
    }

    void _goToCreateStore() async {
      Navigator.pushNamed(
        context,
        AppRoute.createStoreScreen,
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<CreateAccountBloc, CreateAccountState>(
            listener: (context, state) {
          if (state is AccountCreated) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Account created successfully!',
              icon: SvgPicture.string(
                SvgIcons.successIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
            _goToCreateStore();
          } else if (state is CreateAccountError) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.error,
              title: 'Error',
              description: '${state.errorMessage}',
              icon: SvgPicture.string(
                SvgIcons.errorIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Error",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Create an Account',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "JK_Sans",
                        color: AppColors.bodyTextColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Enter your details below',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: "JK_Sans",
                        color: AppColors.subTitleTextColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  // AppInputField(
                  //   label: "Username",
                  //   hintText: 'Enter username',
                  //   controller: _userNameController,
                  //   keyboardType: TextInputType.text,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Username is required';
                  //     }

                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: 20),
                  AppInputField(
                    label: "First Name",
                    hintText: 'Enter first name',
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  AppInputField(
                    label: "Last Name",
                    hintText: 'Enter last name',
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  AppInputField(
                    label: "Email",
                    hintText: 'Enter email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  AppInputField(
                    label: "Password",
                    hintText: 'Enter your password',
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$')
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
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  AppButton(
                    label: "Sign Up",
                    // onPressed: _goToCreateStore,
                    isLoading: state is CreateAccountLoading,
                    isDisabled: state is CreateAccountLoading,
                    onPressed: () {
                      // if (_createAccountFormKey.currentState?.validate() ??
                      //     false) {
                      _createAccountBloc.add(
                        CreateAccountRequested(
                          email: _emailController.text,
                          password: _passwordController.text,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          accountType: AccountType.restaurant.type,
                          confirmPassword: _confirmPasswordController.text,
                        ),
                      );
                      // }
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFE5E7EB),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                              color: AppColors.subTitleTextColor,
                              fontSize: 12,
                              fontFamily: "JK_Sans",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFE5E7EB),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      AppAssets.google,
                      height: 24,
                      width: 24,
                    ),
                    label: Text(
                      'Google',
                      style: TextStyle(
                        color: AppColors.bodyTextColor,
                        fontFamily: "JK_Sans",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: AppColors.bodyTextColor,
                      backgroundColor: AppColors.grayBackground,
                      side: BorderSide(color: AppColors.grayBorderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: Size(double.infinity, 50), // Full width
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?",
                            style: TextStyle(
                                color: AppColors.grayTextColor,
                                fontFamily: "JK_Sans",
                                fontSize: 14)),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: _goToLogin,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontFamily: "JK_Sans",
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          );
        }));
  }
}
