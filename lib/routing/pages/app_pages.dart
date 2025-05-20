import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/create_dish.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/edit_dish.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/view_dish.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/create_menu.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/edit_menu.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/view_menu.dart';
import 'package:food_hunt/screens/app/store/orders/children/order_details.dart';
import 'package:food_hunt/screens/app/store/profile/children/change_password/view/change_password.dart';
import 'package:food_hunt/screens/app/store/profile/children/store_details/store_details.dart';
import 'package:food_hunt/screens/app/store/store_layout.dart';
import 'package:food_hunt/screens/app/store/unverified_dashboard/unverified_dashboard.dart';
import 'package:food_hunt/screens/app/user/cart/single_store_cart.dart';
import 'package:food_hunt/screens/app/user/favorites/favorites.dart';
import 'package:food_hunt/screens/app/user/home/search.dart';
import 'package:food_hunt/screens/app/user/profile/children/add_address/view/add_address.dart';
// import 'package:food_hunt/screens/app/user/home/search_screen.dart';
import 'package:food_hunt/screens/app/user/profile/children/password/view/change_password.dart';
import 'package:food_hunt/screens/app/user/profile/children/profile_details/profile_details.dart';
import 'package:food_hunt/screens/app/user/profile/children/saved_addresses/saved_addresses.dart';
import 'package:food_hunt/screens/app/user/store/store.dart';
import 'package:food_hunt/screens/app/user/tab_layout.dart';
import 'package:food_hunt/screens/auth/create_account/view/create_account_store.dart';
import 'package:food_hunt/screens/auth/create_account/view/create_account_user.dart';
import 'package:food_hunt/screens/auth/create_restaurant/view/create_restaurant.dart';
import 'package:food_hunt/screens/auth/forgot_password/create_new_password.dart';
import 'package:food_hunt/screens/auth/forgot_password/reset_password.dart';
import 'package:food_hunt/screens/auth/forgot_password/verify_code.dart';
import 'package:food_hunt/screens/auth/login/view/login.dart';
import 'package:food_hunt/screens/auth/pre_login/pre_login.dart';
// import 'package:food_hunt/screens/auth/sign_up.dart';
import 'package:food_hunt/screens/auth/verify_email/view/verify_email.dart';
import 'package:food_hunt/screens/auth/verify_kyc/view/verify_kyc.dart';
import 'package:food_hunt/screens/onboarding/onboarding.dart';
import 'package:food_hunt/screens/select_location/choose_address.dart';
import 'package:food_hunt/screens/select_location/confirm_location.dart';
// import 'package:food_hunt/screens/select_location/confirm_location.dart';
import 'package:food_hunt/screens/select_location/share_location.dart';

abstract class AppPages {
  static final page = {
    // Onboarding
    AppRoute.onboardingScreen: (_) => OnboardingScreen(),
    AppRoute.preLoginScreen: (_) => PreLoginScreen(),

    // Auth
    AppRoute.signUpScreen: (_) => const CreateUserAccountTypeScreen(),
    AppRoute.storeSignUpScreen: (_) => const CreateStoreAccountTypeScreen(),
    AppRoute.userSignUpScreen: (_) => const CreateUserAccountTypeScreen(),
    AppRoute.verifyEmailScreen: (_) => const VerifyEmailAddress(),
    AppRoute.shareLocationScreen: (_) => LocationScreen(),
    // AppRoute.enterAddressScreen: (_) => ConfirmLocationScreen(),

    // AppRoute.confirmLocationScreen: (_) => MapConfirmationScreen(),
    AppRoute.chooseAddressScreen: (_) => ChooseAddressScreen(),
    AppRoute.addAddressScreen: (_) => AddAddressScreen(),

    AppRoute.loginScreen: (_) => LoginScreen(),
    // AppRoute.loginScreen: (_) => LocationScreen(),

    AppRoute.resetPasswordScreen: (_) => const ResetPasswordScreen(),
    AppRoute.verifyOTPScreen: (_) => const VerifyCode(),
    AppRoute.setNewPasswordScreen: (_) => const CreateNewPassword(),

    AppRoute.createStoreScreen: (_) => const CreateStoreScreen(),
    AppRoute.kycScreen: (_) => const VerifyKYCScreen(),
    AppRoute.unverifiedKYCDashboard: (_) => UnVerifiedStoreDashboard(),

    // App
    AppRoute.appLayout: (_) => AppScreen(),
    AppRoute.searchScreen: (_) => SearchScreen(),

    AppRoute.storeScreen: (_) => StorePage(),

    AppRoute.storeCart: (_) => StoreCartPage(),

    AppRoute.profileDetails: (_) => ProfileDetailsScreen(),
    AppRoute.savedAddresses: (_) => SavedAddressesScreen(),
    AppRoute.favorites: (_) => FavoritesScreen(),

    // Store
    AppRoute.storeLayout: (_) => StoreLayout(),

    AppRoute.storeOrderDetails: (_) => StoreOrderDetails(),

    // AppRoute.menuItem: (_) => MenuItemScreen(),
    AppRoute.createNewMenuItem: (_) => CreateMenu(),
    AppRoute.editMenu: (_) => EditMenu(),
    AppRoute.viewMenu: (_) => ViewMenu(),

    AppRoute.editDish: (_) => EditDish(),
    AppRoute.createDish: (_) => CreateDish(),
    AppRoute.viewDish: (_) => ViewDish(),

    AppRoute.changeStorePassword: (_) => StoreChangePassword(),
    AppRoute.storeDetailsScreen: (_) => StoreDetails(),
    AppRoute.businessHours: (_) => StoreChangePassword(),

    AppRoute.changeUserPassword: (_) => UserChangePassword(),

    // AppRoute.viewDish: (_) => StorePofile(),

    // AppRoute.menuItem: (_) => MenuItemScreen(),
    // AppRoute.createNewMenuItem: (_) => CreateNewMenuItemScreen(),

    // AppRoute.createOptionGroup: (_) => EditOptionItemScreen(),
    // AppRoute.editOptionGroup: (_) => CreateOptionItemScreen(),

    // AppRoute.editOptionItem: (_) => EditOptionItemScreen(),
    // AppRoute.createOptionItem: (_) => CreateOptionItemScreen(),
  };
}
