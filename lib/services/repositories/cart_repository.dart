// services/cart_storage_service.dart
import 'package:food_hunt/services/models/core/cart.new.dart';
import 'package:food_hunt/services/models/core/store.new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartStorageService {
  static const String _cartKey = 'multi_store_cart';

  // Save entire cart to SharedPreferences
  static Future<void> saveCart(List<Store> stores) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = stores
        .map((store) => {
              'id': store.id,
              'name': store.name,
              'logoUrl': store.logoUrl,
              'items': store.items
                  .map((item) => {
                        'id': item.id,
                        'name': item.name,
                        'price': item.price,
                        'imageUrl': item.imageUrl,
                        'quantity': item.quantity,
                        'additionalDetails': item.additionalDetails
                      })
                  .toList()
            })
        .toList();

    await prefs.setString(_cartKey, json.encode(cartJson));
  }

  // Load cart from SharedPreferences
  static Future<List<Store>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString(_cartKey);

    if (cartString == null) return [];

    final List<dynamic> cartJson = json.decode(cartString);

    return cartJson
        .map((storeJson) => Store(
            id: storeJson['id'],
            name: storeJson['name'],
            logoUrl: storeJson['logoUrl'],
            items: (storeJson['items'] as List)
                .map((itemJson) => CartItem(
                    id: itemJson['id'],
                    name: itemJson['name'],
                    price: itemJson['price'],
                    imageUrl: itemJson['imageUrl'],
                    quantity: itemJson['quantity'],
                    additionalDetails: itemJson['additionalDetails']))
                .toList()))
        .toList();
  }

  // Clear entire cart
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
