import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_hunt/core/config/url.dart';
import 'package:food_hunt/screens/app/store/dashboard/bloc/overview_bloc.dart';
import 'package:food_hunt/screens/app/store/dashboard/bloc/popular_meals_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/bloc/create_dish_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/bloc/edit_dish_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/dishes/bloc/fetch_dishes_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/create_menu_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/edit_menu_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_menu_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_menu_dishes_bloc.dart';
import 'package:food_hunt/screens/app/store/menu/children/menu_overview/bloc/fetch_single_menu_bloc.dart';
import 'package:food_hunt/screens/app/store/orders/bloc/completed_orders_bloc.dart';
import 'package:food_hunt/screens/app/store/orders/bloc/new_orders_bloc.dart';
import 'package:food_hunt/screens/app/store/orders/bloc/ongoing_orders_bloc.dart';
import 'package:food_hunt/screens/app/store/profile/bloc/store_profile_bloc.dart';
import 'package:food_hunt/screens/app/user/favorites/bloc/favorite_items_bloc.dart';
import 'package:food_hunt/screens/app/user/favorites/bloc/favorite_stores_bloc.dart';
import 'package:food_hunt/screens/app/user/store/bloc/dishes_bloc.dart';
import 'package:food_hunt/services/api.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

class RestaurantDependencies {
  static final apiService = ApiService(baseUrl: baseUrl);
  static final storage = FlutterSecureStorage();

  static RestaurantRepository get restaurantRepository => RestaurantRepository(
        apiService,
      );

  static StoreOverviewBloc get storeOverviewBloc =>
      StoreOverviewBloc(restaurantRepository)..add(FetchStoreOverview());

  static StoreProfileBloc get storeProfileBloc =>
      StoreProfileBloc(restaurantRepository)..add(FetchStoreProfile());

  static CreateMenuBloc get createMenuBloc =>
      CreateMenuBloc(restaurantRepository);

  static EditMenuBloc get editMenuBloc => EditMenuBloc(restaurantRepository);

  static FetchMenuBloc get fetchMenuBloc =>
      FetchMenuBloc(restaurantRepository)..add(FetchAllMenu());

  static CreateDishBloc get createDishBloc =>
      CreateDishBloc(restaurantRepository);

  static EditDishBloc get editDishBloc => EditDishBloc(restaurantRepository);

  static FetchDishBloc get fetchDishBloc =>
      FetchDishBloc(restaurantRepository)..add(FetchAllDishes());

  static StoreDishesBloc get fetchStoreDishesBloc =>
      StoreDishesBloc(restaurantRepository);

  static FetchSingleMenuBloc get fetchSingleMenuBloc =>
      FetchSingleMenuBloc(restaurantRepository);

  static FetchMenuDishesBloc get fetchMenuDishesBloc =>
      FetchMenuDishesBloc(restaurantRepository);

  static PopularMealsBloc get fetchPopularDishesBloc =>
      PopularMealsBloc(restaurantRepository)..add(FetchPopularMeals());

  // Orders
  static NewOrdersBloc get fetchNewOrdersBloc =>
      NewOrdersBloc(restaurantRepository)..add(FetchNewOrders());

  static OngoingOrdersBloc get fetchOngoingOrdersBloc =>
      OngoingOrdersBloc(restaurantRepository)..add(FetchOngoingOrders());

  static CompletedOrdersBloc get fetchCompletedOrdersBloc =>
      CompletedOrdersBloc(restaurantRepository)..add(FetchCompletedOrders());

  // favorites
  static FavoriteItemsBloc get favoriteItemsBloc =>
      FavoriteItemsBloc(restaurantRepository)..add(LoadFavoriteItems());

  static FavoriteStoresBloc get favoriteStoresBloc =>
      FavoriteStoresBloc(restaurantRepository)..add(LoadFavoriteStores());
}
