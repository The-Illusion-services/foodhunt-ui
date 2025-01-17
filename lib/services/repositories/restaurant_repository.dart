import 'dart:io';
import 'package:food_hunt/services/api.dart';
import 'package:http/http.dart' as http;

class RestaurantRepository {
  final ApiService _apiService;

  RestaurantRepository(
    this._apiService,
  );

  Future<Map<String, dynamic>> getStoreOverview() async {
    try {
      final response = await _apiService.get(
        '/restaurant/overview/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<Map<String, dynamic>> getStoreProfile(
      {required String restaurantId}) async {
    try {
      final response = await _apiService.get(
        '/restaurant/profile/${restaurantId}/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<Map<String, dynamic>> updateStoreProfile(
      {required String restaurantId}) async {
    try {
      final response = await _apiService.put(
        '/restaurant/profile/${restaurantId}/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<dynamic>> fetchAllMenu({required String restaurantId}) async {
    try {
      final response = await _apiService.get(
        '/restaurant/menus/?restaurant_id=$restaurantId',
      );

      print(response);

      return response;
    } catch (e) {
      print(e);
      throw (e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchSingleMenu({
    required String menuId,
  }) async {
    try {
      final response = await _apiService.get(
        '/restaurant/menu/${menuId}/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> createMenu({
    required String restaurant,
    required String name,
    required String description,
    File? menuImage,
  }) async {
    try {
      final fields = {
        'name': name.toString(),
        'description': description.toString(),
        'restaurant': restaurant.toString(),
      };

      final file = await http.MultipartFile.fromPath(
        'menu_image',
        menuImage!.path,
      );

      final response = await _apiService.multipartPost(
          '/restaurant/menus/create/',
          fields: fields,
          files: file);

      print(response);
      // return response.data;
    } catch (e) {
      print('Error: $e');
      throw Exception('Error creating menu: $e');
    }
  }

  Future<void> updateMenu({
    required String menuId,
    required String restaurant,
    required String name,
    required String description,
    File? menuImage,
  }) async {
    try {
      final fields = {
        'name': name.toString(),
        'description': description.toString(),
        'restaurant': restaurant.toString(),
      };

      final file = await http.MultipartFile.fromPath(
        'menu_image',
        menuImage!.path,
      );

      final response = await _apiService.multipartPut(
          '/restaurant/menus/${menuId}/update/',
          fields: fields,
          files: file);

      print(response);
      // return response.data;
    } catch (e) {
      print('Error: $e');
      throw Exception('Error updating menu: $e');
    }
  }

  Future<void> createDish(
      {required String menuId,
      required String name,
      required String description,
      required String price,
      required File dishImage,
      required bool isAvailable}) async {
    try {
      final fields = {
        'name': name.toString(),
        'description': description.toString(),
        'price': price.toString(),
        'is_available': isAvailable.toString(),
      };

      print(isAvailable);
      print(isAvailable.toString());

      final file = await http.MultipartFile.fromPath(
        'dish_image',
        dishImage.path,
      );

      final response = await _apiService.multipartPost(
          '/restaurant/menus/${menuId}/dishes/create/',
          fields: fields,
          files: file);

      print(response);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> editDish(
      {required String dishId,
      required String name,
      required String description,
      required String price,
      required File dishImage,
      required bool isAvailable}) async {
    try {
      final fields = {
        'name': name.toString(),
        'description': description.toString(),
        'price': price.toString(),
        'is_available': isAvailable.toString(),
      };

      print(isAvailable);
      print(isAvailable.toString());

      final file = await http.MultipartFile.fromPath(
        'dish_image',
        dishImage.path,
      );

      final response = await _apiService.multipartPost(
          '/restaurant/dishes/${dishId}/update/',
          fields: fields,
          files: file);

      print(response);
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<dynamic>> fetchAllDishes({required String restaurantId}) async {
    try {
      final response = await _apiService.get(
        '/restaurant/dishes/${restaurantId}/all/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchSingleDish() async {
    try {
      final response = await _apiService.get(
        '/restaurant/menus/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<dynamic>> fetchMenuDishes({required String menuId}) async {
    try {
      final response = await _apiService.get(
        '/restaurant/menus/${menuId}/dishes/',
      );

      print(response);

      return response;
    } catch (e) {
      print(e);
      throw (e.toString());
    }
  }

  // Meals
  Future<List<dynamic>> fetchPopularDishes(
      {required String restaurantId}) async {
    try {
      final response = await _apiService.get(
        '/restaurant/dishes/${restaurantId}/all/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  // Orders
  Future<List<dynamic>> fetchAllOrders({required String restaurantId}) async {
    try {
      final response = await _apiService.get(
        '/restaurant/order/history/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<dynamic>> fetchNewOrders({required String restaurantId}) async {
    try {
      final response = await _apiService.get(
        '/restaurant/order/history/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  // Orders
  Future<List<dynamic>> fetchOngoingOrders(
      {required String restaurantId}) async {
    try {
      final response = await _apiService.get(
        '/restaurant/order/history/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }

  // Orders
  Future<List<dynamic>> fetchCompletedOrders(
      {required String restaurantId}) async {
    try {
      final response = await _apiService.get(
        '/restaurant/order/history/',
      );

      print(response);

      return response;
    } catch (e) {
      throw (e.toString());
    }
  }
}
