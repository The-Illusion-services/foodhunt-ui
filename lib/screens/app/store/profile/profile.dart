import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/store/profile/bloc/store_profile_bloc.dart';
import 'package:food_hunt/screens/app/store/profile/children/change_password/bloc/forgot_password_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/settings_item.dart';

class StoreProfileScreen extends StatefulWidget {
  @override
  StoreProfileScreenState createState() => StoreProfileScreenState();
}

class StoreProfileScreenState extends State<StoreProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<StoreProfileBloc, StoreProfileState>(
        builder: (context, state) {
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
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30))),
                  child: Column(children: [
                    SizedBox(
                      height: 110.0,
                    ),
                    state is StoreProfileLoading
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
                            child: state is StoreProfileLoaded &&
                                    state.profileData['restaurant']
                                            ['profile_image'] !=
                                        null
                                ? ClipOval(
                                    child: Image.network(
                                      state.profileData['restaurant']
                                          ['profile_image'],
                                      fit: BoxFit.cover,
                                      width: 100.0,
                                      height: 100.0,
                                    ),
                                  )
                                : Icon(Icons.add_a_photo_rounded,
                                    size: 32.0, color: AppColors.primary),
                          ),
                    SizedBox(
                      height: 10.0,
                    ),
                    state is StoreProfileLoading
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
                            state is StoreProfileLoaded &&
                                    state.profileData['restaurant']['name'] !=
                                        null
                                ? state.profileData['restaurant']['name']
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
                    state is StoreProfileLoading
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
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              state is StoreProfileLoaded &&
                                      state.profileData['restaurant']['address']
                                              ['address'] !=
                                          null
                                  ? state.profileData['restaurant']['address']
                                      ['address']
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
                            .read<StoreProfileBloc>()
                            .add(FetchStoreProfile());
                        return;
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: ListView(
                            children: [
                              // Personal
                              _buildSettingsGroup('Store info', [
                                SettingsItem(
                                  icon: SvgIcons.storeIcon,
                                  title: 'Store details',
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoute.storeDetailsScreen);
                                  },
                                ),
                                const SizedBox(height: 11),
                                SettingsItem(
                                  icon: SvgIcons.savedAddressesIcon,
                                  title: 'Set business hours',
                                  onTap: () {
                                    // Navigator.pushNamed(
                                    //     context, AppRoute.businessHours);
                                  },
                                ),
                                const SizedBox(height: 11),
                                SettingsItem(
                                  icon: SvgIcons.usersIcon,
                                  title: 'Manage users',
                                  onTap: () {},
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
                                  icon: SvgIcons.passwordIcon,
                                  title: 'Change password',
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoute.changeStorePassword);
                                    context
                                        .read<ForgotPasswordBloc>()
                                        .add(SendOtp());
                                  },
                                ),
                              ]),

                              // Support
                              _buildSettingsGroup('Support', [
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
                                    AuthService authService = AuthService();

                                    await authService.clearAuthData();

                                    Navigator.popUntil(
                                        context,
                                        ModalRoute.withName(
                                            AppRoute.preLoginScreen));
                                    Navigator.pushNamed(
                                        context, AppRoute.preLoginScreen);
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
