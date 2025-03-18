// import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/user/profile/bloc/user_profile_bloc.dart';
import 'package:food_hunt/screens/app/user/profile/children/password/bloc/forgot_password_bloc.dart';
import 'package:food_hunt/screens/auth/login/bloc/login_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/settings_item.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, state) {
          // Avatar _avatar = DiceBearBuilder(
          //   seed: state is UserProfileLoaded
          //       ? state.profileData['first_name'] +
          //           " " +
          //           state.profileData['last_name']
          //       : "John Doe",
          // ).build();

          // Uri uri = _avatar.svgUri;

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30))),
                      child: Column(children: [
                        SizedBox(
                          height: 110.0,
                        ),
                        state is UserProfileLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.orange[300]!,
                                highlightColor: Colors.orange[100]!,
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.orange[100]!,
                                child: ClipOval(
                                  child: Image.asset(
                                    AppAssets.profilePicture,
                                    fit: BoxFit.cover,
                                    width: 100.0,
                                    height: 100.0,
                                  ),
                                )),
                        SizedBox(
                          height: 10.0,
                        ),
                        state is UserProfileLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.orange[300]!,
                                highlightColor: Colors.orange[100]!,
                                child: Container(
                                  width: 100.0,
                                  height: 16.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                            : Text(
                                state is UserProfileLoaded &&
                                        state.profileData['first_name'] != null
                                    ? state.profileData['first_name'] +
                                        " " +
                                        state.profileData['last_name']
                                    : "...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontFamily: "JK_Sans",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        SizedBox(
                          height: 2.0,
                        ),
                        state is UserProfileLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.orange[300]!,
                                highlightColor: Colors.orange[100]!,
                                child: Container(
                                  width: 200.0,
                                  height: 16.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                            : Text(
                                state is UserProfileLoaded &&
                                        state.profileData['email'] != null
                                    ? state.profileData['email']
                                    : "...",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontFamily: "JK_Sans",
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                      ]),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            context
                                .read<UserProfileBloc>()
                                .add(FetchUserProfile());
                            return;
                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 24),
                              child: ListView(
                                children: [
                                  // Personal
                                  _buildSettingsGroup('Personal', [
                                    SettingsItem(
                                      icon: SvgIcons.profileDetailsIcon,
                                      title: 'Profile details',
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoute.profileDetails);
                                      },
                                    ),
                                    const SizedBox(height: 11),
                                    SettingsItem(
                                      icon: SvgIcons.savedAddressesIcon,
                                      title: 'Saved addresses',
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoute.savedAddresses);
                                      },
                                    ),
                                  ]),

                                  // More
                                  _buildSettingsGroup('More', [
                                    SettingsItem(
                                      icon: SvgIcons.profileNotificationsIcon,
                                      title: 'Notifications',
                                      onTap: () {},
                                    ),
                                    const SizedBox(height: 11),
                                    SettingsItem(
                                      icon: SvgIcons.profileHeartIcon,
                                      title: 'Favorites',
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoute.favorites);
                                      },
                                    ),
                                    const SizedBox(height: 11),
                                    SettingsItem(
                                      icon: SvgIcons.passwordIcon,
                                      title: 'Password',
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            AppRoute.changeUserPassword);
                                        context
                                            .read<UserForgotPasswordBloc>()
                                            .add(SendOtp());
                                      },
                                    ),
                                  ]),

                                  // Support
                                  _buildSettingsGroup('Support', [
                                    SettingsItem(
                                      icon: SvgIcons.faqIon,
                                      title: 'FAQ',
                                      onTap: () {},
                                    ),
                                    const SizedBox(height: 11),
                                    SettingsItem(
                                      icon: SvgIcons.supportIcon,
                                      title: 'Contact support',
                                      onTap: () {
                                        // Handle contact support tap
                                      },
                                    ),
                                  ]),

                                  // Legal
                                  _buildSettingsGroup('Legal', [
                                    SettingsItem(
                                      icon: SvgIcons.touIcon,
                                      title: 'Terms of use',
                                      onTap: () {
                                        // Handle FAQ tap
                                      },
                                    ),
                                    const SizedBox(height: 11),
                                    SettingsItem(
                                      icon: SvgIcons.policyIcon,
                                      title: 'Privacy policy',
                                      onTap: () {
                                        // Handle contact support tap
                                      },
                                    ),
                                  ]),

                                  _buildSettingsGroup('Accounts', [
                                    SettingsItem(
                                      icon: SvgIcons.policyIcon,
                                      title: 'Logout',
                                      onTap: () async {
                                        context
                                            .read<LoginBloc>()
                                            .add(LogoutRequested());
                                        Navigator.pushNamed(
                                            context, AppRoute.loginScreen);
                                      },
                                    ),
                                  ]),
                                ],
                              )))),
                ],
              ),
            ],
          );
        }));
  }

  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.subTitleTextColor,
          ),
        ),
        const SizedBox(height: 8),
        ...items,
        const SizedBox(height: 24),
      ],
    );
  }
}
