// import 'package:flutter/widgets.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/api.dart';
import 'package:food_hunt/services/models/core/cart.recent.dart';
import 'package:food_hunt/services/models/core/orders.dart';

class OrdersRepository {
  final ApiService _apiService;
  final AuthService authService = AuthService();

  OrdersRepository(this._apiService);

  Future<Map<String, dynamic>> createOrder(
      {required int addressId,
      required double amount,
      required String paymentReference,
      required String storeId,
      required List<CartItem> items}) async {
    try {
      final payload = {
        'reference': paymentReference,
        'address_id': addressId,
        'restaurant_id': storeId,
        'items': items
            .map((item) => {
                  'dish_id': item.foodItem.id,
                  'quantity': item.quantity,
                })
            .toList(),
        'amount': amount.toInt(),
      };

      print(payload);

      final response =
          await _apiService.post('/restaurant/order/create/', data: payload);

      return response;
    } catch (e) {
      print('Error creating orders: $e');
      throw e.toString();
    }
  }

  Future<List<Order>> getAllOrders() async {
    try {
      final response = await _apiService.get('/restaurant/order/history/');

      print(response);

      // Check if response is a Map and has a data field
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final List<dynamic> ordersList = response['data'];

        return ordersList
            .map((orderJson) => Order.fromJson(orderJson))
            .toList();
      }

      // If response is directly a List
      if (response is List) {
        return response.map((orderJson) => Order.fromJson(orderJson)).toList();
      }
      throw 'Invalid response format';
    } catch (e) {
      print('Error fetching orders: $e');
      throw e.toString();
    }
  }

  // Future<Order> getOrderById({required String orderId}) async {
  //   try {
  //     final response = await _apiService.get('/restaurant/order/${orderId}/');

  //     print(response);

  //     // // Check if response is a Map and has a data field
  //     // if (response is Map<String, dynamic> && response.containsKey('data')) {
  //     //   final List<dynamic> ordersList = response['data'];

  //     //   return ordersList
  //     //       .map((orderJson) => Order.fromJson(orderJson))
  //     //       .toList();
  //     // }

  //     // // If response is directly a List
  //     // if (response is List) {
  //     //   return response.map((orderJson) => Order.fromJson(orderJson)).toList();
  //     // }
  //     throw 'Invalid response format';
  //   } catch (e) {
  //     print('Error fetching orders: $e');
  //     throw e.toString();
  //   }
  // }

  Future<Order> getOrderById({required String orderId}) async {
    try {
      final response = await _apiService.get('/restaurant/order/$orderId/');

      if (response is Map<String, dynamic>) {
        return Order.fromJson(response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error fetching order: $e');
      throw Exception('Failed to fetch order: $e');
    }
  }
}
