abstract class AppRoute {
  // Onboarding
  static const onboardingScreen = '/onboarding';
  static const preLoginScreen = '/pre_login';

  // Auth
  static const signUpScreen = '/sign_up';
  static const storeSignUpScreen = '/store/sign_up';
  static const userSignUpScreen = '/user/sign_up';

  static const verifyEmailScreen = '/verify_email';
  static const shareLocationScreen = '/share_location';
  static const confirmLocationScreen = '/confirm_location';
  static const enterAddressScreen = '/enter_address';
  static const chooseAddressScreen = '/address/choose';
  static const addAddressScreen = '/address/add';

  static const loginScreen = '/login';
  static const resetPasswordScreen = '/reset_password';
  static const verifyOTPScreen = '/verify_otp';
  static const setNewPasswordScreen = '/set_new_password';

  static const createStoreScreen = "/auth/store/create";
  static const kycScreen = "/auth/store/kyc";
  static const unverifiedKYCDashboard = "/auth/store/unverfied";

  static const appLayout = "/app";
  static const searchScreen = "/search_screen";
  static const storeScreen = "/store";

  static const storeCart = "/cart/store";

  static const profileDetails = "/profile/details";
  static const savedAddresses = "/profile/addresses";
  static const favorites = "/profile/favorites";

  // Store
  static const storeLayout = "/store_layout";

  static const storeOrderDetails = "/store/order_details";

  static const menuItem = "/menu";
  static const createNewMenuItem = "/menu/create";
  static const editMenu = "/menu/edit";
  static const viewMenu = "/menu/view";

  static const editOptionGroup = "/menu/option_group/edit";
  static const createOptionGroup = "/menu/option_group/create";

  static const editOptionItem = "/menu/option_item/edit";
  static const createOptionItem = "/menu/option_item/create";

  static const editDish = "/menu/dish/edit";
  static const createDish = "/menu/dish/create";
  static const viewDish = "/menu/dish/view";

  static const changeStorePassword = "/store/password/change";
  static const storeDetailsScreen = "/store/profile";
  static const businessHours = "/store/hours";

  static const changeUserPassword = "/user/password/change";
}
