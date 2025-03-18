import 'package:flutter/material.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Location _location = Location();
  bool _isLoading = false;

  Future<void> _requestLocation(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    bool serviceEnabled = await _checkServiceEnabled(context);
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    bool permissionGranted = await _checkPermission(context);
    if (!permissionGranted) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final locationData = await _location.getLocation();
      print(locationData);
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoute.chooseAddressScreen);
        // Navigator.pushNamed(context, AppRoute.appLayout);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to get location. Please try again.')),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> _checkServiceEnabled(BuildContext context) async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Location services are required to continue.')),
          );
        }
        return false;
      }
    }
    return true;
  }

  Future<bool> _checkPermission(BuildContext context) async {
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Location permission is required to continue.')),
          );
        }
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(24.0),
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Spacer(),
            Image.asset(
              AppAssets.paper_map,
              height: 250,
              width: 300,
              fit: BoxFit.contain,
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hungry? We've Got Options",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: "JK_Sans",
                        color: AppColors.bodyTextColor,
                        fontSize: 20,
                      ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover your favourite dishes and modern twists from nearby restaurants. Find your favorite foods with just a tap',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontFamily: "JK_Sans",
                        color: AppColors.subTitleTextColor,
                        fontSize: 12,
                      ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 32),
                AppButton(
                  isDisabled: _isLoading,
                  isLoading: _isLoading,
                  label: "Share Location",
                  onPressed: () => _requestLocation(context),
                ),
                // const SizedBox(height: 16),
                // SizedBox(
                //   width: double.infinity,
                //   height: 56,
                //   child: OutlinedButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     style: OutlinedButton.styleFrom(
                //       backgroundColor: AppColors.grayBackground,
                //       side: BorderSide(color: AppColors.grayBorderColor),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(28),
                //       ),
                //     ),
                //     child: Text(
                //       'Enter address manually',
                //       style: TextStyle(
                //         fontFamily: "JK_Sans",
                //         color: AppColors.bodyTextColor,
                //         fontSize: 14,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
