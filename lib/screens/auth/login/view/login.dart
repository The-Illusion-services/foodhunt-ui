import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/auth/login/bloc/login_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    void _goToSignUp() {
      Navigator.pushNamed(context, AppRoute.signUpScreen);
    }

    void _goToForgotPassword() {
      Navigator.pushNamed(context, AppRoute.resetPasswordScreen);
    }

    void _navigateToDashboard(String accountType, bool hasRestaurantProfile) {
      if (accountType == AccountType.buyer.type) {
        Navigator.pushNamed(context, AppRoute.appLayout);
      } else if (accountType == AccountType.restaurant) {
        if (hasRestaurantProfile) {
          Navigator.pushNamed(context, AppRoute.storeLayout);
        } else {
          Navigator.pushNamed(context, AppRoute.createStoreScreen);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoggedIn) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Logged in!.',
              icon: SvgPicture.string(
                SvgIcons.successIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
            _navigateToDashboard(state.accountType, state.hasRestaurantProfile);
          }

          if (state is LoginError) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.error,
              title: 'Error',
              description: '${state.errorMessage}',
              icon: SvgPicture.string(
                SvgIcons.errorIcon,
                width: 20,
                height: 20,
                semanticsLabel: "Success",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
            child: Form(
              key: _loginFormKey, // Attach the GlobalKey to the Form
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "JK_Sans",
                      color: AppColors.bodyTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter your details below',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: "JK_Sans",
                      color: AppColors.subTitleTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 20),
                  AppInputField(
                    label: "Password",
                    hintText: 'Enter password',
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: AppColors.grayTextColor,
                          fontFamily: "JK_Sans",
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: _goToForgotPassword,
                        child: Text(
                          'Tap here',
                          style: TextStyle(
                            color: AppColors.appBlue,
                            fontWeight: FontWeight.w600,
                            fontFamily: "JK_Sans",
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: "Sign In",
                    isLoading: state is LoginLoading,
                    isDisabled: state is LoginLoading,
                    onPressed: () {
                      // Validate the form
                      if (_loginFormKey.currentState!.validate()) {
                        loginBloc.add(
                          LoginRequested(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
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
                        Text("Don't have an account?",
                            style: TextStyle(
                                color: AppColors.grayTextColor,
                                fontFamily: "JK_Sans",
                                fontSize: 14)),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: _goToSignUp,
                          child: Text(
                            'Sign Up',
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
        },
      ),
    );
  }
}
