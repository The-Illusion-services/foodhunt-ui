import 'package:food_hunt/core/config/url.dart';
import 'package:food_hunt/screens/app/user/home/bloc/search_bloc.dart';
import 'package:food_hunt/screens/app/user/store/bloc/store_bloc.dart';
import 'package:food_hunt/services/api.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';
import 'package:food_hunt/services/repositories/user_repository.dart';

class UserDependencies {
  static final apiService = ApiService(baseUrl: baseUrl);

  static UserRepository get userRepository => UserRepository(
        apiService,
      );

  static RestaurantRepository get restaurantRepository => RestaurantRepository(
        apiService,
      );

  static SearchBloc get searchBloc => SearchBloc(userRepository);

  static UserStoreBloc get userStoreBloc => UserStoreBloc(restaurantRepository);
}
