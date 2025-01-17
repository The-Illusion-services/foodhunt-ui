import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/states/error_state.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/profile/bloc/user_profile_bloc.dart';
import 'package:food_hunt/screens/app/user/profile/children/profile_details/bloc/update_user_profile_details_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/inputs/phone_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:toastification/toastification.dart';

class ProfileDetailsScreen extends StatefulWidget {
  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  // final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(FetchUserProfile());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
                    "Profile Details",
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
        body: BlocListener<UpdateUserDetailsBloc, UpdateUserDetailsState>(
            listener: (context, state) {
          if (state is UserDetailsUpdated) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.success,
              title: 'Success',
              description: 'Profile details updated successfully!',
              icon: SvgPicture.string(SvgIcons.successIcon),
            );
            Navigator.pop(context);
          } else if (state is UserDetailsUpdateError) {
            ToastWidget.showToast(
              context: context,
              type: ToastificationType.error,
              title: 'Error',
              description: state.message,
              icon: SvgPicture.string(SvgIcons.errorIcon),
            );
          }
        }, child: BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (context, state) {
          if (state is UserProfileLoading) {
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
          } else if (state is UserProfileLoaded) {
            _firstNameController.text = state.profileData['first_name'] ?? '';
            _lastNameController.text = state.profileData['last_name'] ?? '';
            _emailController.text = state.profileData['email'] ?? '';
            _phoneController.text = state.profileData['phone'] ?? '';

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                                  AssetImage(AppAssets.profilePicture),
                              backgroundColor: Colors.white,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.string(
                                      SvgIcons.cameraIcon,
                                      colorFilter: ColorFilter.mode(
                                          Color(0xFF333333), BlendMode.srcIn),
                                      width: 13,
                                      height: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildProfileForm(),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: AppButton(label: "Save Changes"),
                ),
              ],
            );
          } else if (state is UserProfileError) {
            return errorState(
                context: context,
                text: state.message,
                onTap: () {
                  context.read<UserProfileBloc>().add(FetchUserProfile());
                });
          } else {
            return SizedBox.shrink();
          }
        })));
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        PhoneNumberInput(
          label: "Phone number",
          hintText: 'Enter phone number',
          controller: _phoneController,
        ),
      ],
    );
  }
}
