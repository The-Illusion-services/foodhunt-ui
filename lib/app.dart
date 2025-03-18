import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/routing/pages/app_pages.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_bloc.new.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_event.new.dart';
import 'package:food_hunt/services/dependencies/auth_dependencies.dart';
import 'package:food_hunt/services/dependencies/orders_dependencies.dart';
import 'package:food_hunt/services/dependencies/restaurant_dependencies.dart';
import 'package:food_hunt/services/dependencies/user_dependencies.dart';
import 'package:food_hunt/state/app_state/app_bloc.dart';
import 'package:food_hunt/state/store/store_tab_bloc.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<String> _determineInitialRoute(BuildContext context) async {
    final AuthService authService = AuthService();
    final bool isLoggedIn = await authService.isLoggedIn();
    final String? accountType = await authService.getAccountType();
    final bool isVerified = await authService.isVerified();
    final bool hasRestaurantProfile = await authService.hasRestaurant();
    // final bool hasRestaurantProfile = await authService.hs();

    print(isLoggedIn);
    print(accountType);
    print(isVerified);
    print(hasRestaurantProfile);

    if (!isLoggedIn) {
      return AppRoute.preLoginScreen;
    }

    if (accountType == 'buyer') {
      return isVerified ? AppRoute.appLayout : AppRoute.verifyEmailScreen;
    }

    if (accountType == 'restaurant') {
      if (!hasRestaurantProfile) {
        return AppRoute.createStoreScreen;
      }
      if (isVerified) {
        return AppRoute.storeLayout;
      } else {
        return AppRoute.unverifiedKYCDashboard;
      }
    }

    // Default route in case of unexpected values
    return AppRoute.preLoginScreen;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String>(
      future: _determineInitialRoute(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the future to complete
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          // Handle errors in fetching the initial route
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                  child: Text('Something went wrong. Please restart the app.')),
            ),
          );
        }

        final _initialRoute = snapshot.data!;

        // final authRepository = AuthRepository();
        // final userAddressBloc =
        //     UserAddressBloc(authRepository, AddressService());
        // final addressService = AddressService(userAddressBloc);

        // // Load addresses from SharedPreferences when the app starts
        // userAddressBloc.add(LoadAddressesFromPrefs());

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => CartBloc()..add(LoadCart()),
            ),
            BlocProvider(
              create: (_) => TabBloc()..add(OnInitialTabEvent()),
            ),
            BlocProvider(
              create: (_) => StoreTabBloc()..add(OnStoreDashboardTabEvent()),
            ),
            BlocProvider(
              create: (context) => AuthDependencies.loginBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.createAccountBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.createStoreBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.verifyCodeBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.resendVerifyCodeBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.verifyKYCBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.userProfileBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.updateUserProfileBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.storeResetPasswordBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.forgotPasswordBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.userResetPasswordBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.userForgotPasswordBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.storeOverviewBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.storeProfileBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.updateStoreProfileBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.createMenuBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.editMenuBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.fetchMenuBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.fetchSingleMenuBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.fetchMenuDishesBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.createDishBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.editDishBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.fetchDishBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.fetchStoreDishesBloc,
            ),
            BlocProvider(
              create: (context) =>
                  RestaurantDependencies.fetchPopularDishesBloc,
            ),

            // Orders
            BlocProvider(
              create: (context) => OrdersDependencies.ordersBloc,
            ),
            BlocProvider(
              create: (context) => OrdersDependencies.getOrderDetailsBloc,
            ),
            BlocProvider(
              create: (context) => OrdersDependencies.createOrdersBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.fetchNewOrdersBloc,
            ),
            BlocProvider(
              create: (context) =>
                  RestaurantDependencies.fetchOngoingOrdersBloc,
            ),
            BlocProvider(
              create: (context) =>
                  RestaurantDependencies.fetchCompletedOrdersBloc,
            ),

            // Address
            BlocProvider(
              create: (context) => AuthDependencies.addAddressBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.userAddressBloc,
            ),

            //Restaurants
            BlocProvider(
              create: (context) => AuthDependencies.restaurantsBloc,
            ),
            BlocProvider(
              create: (context) => AuthDependencies.allStoresBloc,
            ),

            //Favorites
            BlocProvider(
              create: (context) => RestaurantDependencies.favoriteItemsBloc,
            ),
            BlocProvider(
              create: (context) => RestaurantDependencies.favoriteStoresBloc,
            ),

            //User
            BlocProvider(
              create: (context) => UserDependencies.searchBloc,
            ),
            BlocProvider(
              create: (context) => UserDependencies.userStoreBloc,
            ),
          ],
          child: MaterialApp(
            title: 'Food Hunt',
            theme: ThemeData(fontFamily: Font.jkSans.fontName),
            color: Colors.transparent,
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: scaffoldMessenger,
            initialRoute: _initialRoute,
            routes: AppPages.page,
          ),
        );
      },
    );
  }
}
