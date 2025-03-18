import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_hunt/core/config/url.dart';
import 'package:food_hunt/screens/app/store/profile/children/change_password/bloc/forgot_password_bloc.dart';
import 'package:food_hunt/screens/app/store/profile/children/change_password/bloc/reset_password_bloc.dart';
import 'package:food_hunt/screens/app/store/profile/children/store_details/bloc/upload_store_details_bloc.dart';
import 'package:food_hunt/screens/app/user/home/bloc/address_bloc.dart';
import 'package:food_hunt/screens/app/user/home/bloc/all_stores_bloc.dart';
import 'package:food_hunt/screens/app/user/home/bloc/restaurants_bloc.dart';
import 'package:food_hunt/screens/app/user/profile/bloc/user_profile_bloc.dart';
import 'package:food_hunt/screens/app/user/profile/children/password/bloc/forgot_password_bloc.dart';
import 'package:food_hunt/screens/app/user/profile/children/password/bloc/reset_password_bloc.dart';
import 'package:food_hunt/screens/app/user/profile/children/profile_details/bloc/update_user_profile_details_bloc.dart';
import 'package:food_hunt/screens/auth/create_account/bloc/create_account_bloc.dart';
import 'package:food_hunt/screens/auth/create_restaurant/bloc/create_restaurant_bloc.dart';
import 'package:food_hunt/screens/auth/login/bloc/login_bloc.dart';
import 'package:food_hunt/screens/auth/verify_email/bloc/send_otp_bloc.dart';
import 'package:food_hunt/screens/auth/verify_email/bloc/verify_otp_bloc.dart';
import 'package:food_hunt/screens/auth/verify_kyc/bloc/verify_kyc_bloc.dart';
import 'package:food_hunt/screens/app/user/profile/children/add_address/bloc/add_address_bloc.dart';
import 'package:food_hunt/services/address_service.dart';
import 'package:food_hunt/services/api.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

class AuthDependencies {
  static final apiService = ApiService(baseUrl: baseUrl);
  static final storage = FlutterSecureStorage();

  static AuthRepository get authRepository =>
      AuthRepository(apiService, storage);

  static AddressService get addressService => AddressService();

  static LoginBloc get loginBloc => LoginBloc(authRepository);
  static CreateAccountBloc get createAccountBloc =>
      CreateAccountBloc(authRepository);

  static CreateStoreBloc get createStoreBloc => CreateStoreBloc(authRepository);
  static UpdateStoreDetailsBloc get updateStoreProfileBloc =>
      UpdateStoreDetailsBloc(authRepository);

  static VerifyKYCBloc get verifyKYCBloc => VerifyKYCBloc(authRepository);

  static VerifyCodeBloc get verifyCodeBloc => VerifyCodeBloc(authRepository);

// Password - Store
  static ResendVerifyCodeBloc get resendVerifyCodeBloc =>
      ResendVerifyCodeBloc(authRepository);

  static StoreResetPasswordBloc get storeResetPasswordBloc =>
      StoreResetPasswordBloc(authRepository);

  static ForgotPasswordBloc get forgotPasswordBloc =>
      ForgotPasswordBloc(authRepository);

// Password - User

  static UserResetPasswordBloc get userResetPasswordBloc =>
      UserResetPasswordBloc(authRepository);

  static UserForgotPasswordBloc get userForgotPasswordBloc =>
      UserForgotPasswordBloc(authRepository);

// Address - User
  static AddAddressBloc get addAddressBloc =>
      AddAddressBloc(authRepository, addressService);

  static UserAddressBloc get userAddressBloc =>
      UserAddressBloc(authRepository, addressService)..add(FetchUserAddress());

  // Restaurant
  static RestaurantsBloc get restaurantsBloc =>
      RestaurantsBloc(authRepository)..add(FetchRestaurants());

  static AllRestaurantsBloc get allStoresBloc =>
      AllRestaurantsBloc(authRepository)..add(FetchAllRestaurants());

  // User

  static UserProfileBloc get userProfileBloc =>
      UserProfileBloc(authRepository)..add(FetchUserProfile());

  static UpdateUserDetailsBloc get updateUserProfileBloc =>
      UpdateUserDetailsBloc(authRepository);
}
