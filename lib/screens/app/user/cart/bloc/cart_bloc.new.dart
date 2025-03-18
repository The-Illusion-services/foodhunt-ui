import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_event.new.dart';
import 'package:food_hunt/screens/app/user/cart/bloc/cart_state.new.dart';
import 'package:food_hunt/services/models/core/cart.recent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_addToCart);
    on<RemoveFromCart>(_removeFromCart);
    on<ClearCart>(_clearCart);
    on<ClearStoreCart>(_clearStoreCart);
    on<LoadCart>(_loadCart);
    on<DecrementQuantity>(_decrementQuantity);
  }

  void _addToCart(AddToCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    List<StoreCart> storeCarts = cartJson != null
        ? (json.decode(cartJson) as List)
            .map((e) => StoreCart.fromJson(e))
            .toList()
        : [];

    // Check if the store already exists in the cart
    final storeIndex = storeCarts
        .indexWhere((store) => store.storeId == event.foodItem.storeId);
    if (storeIndex != -1) {
      // Store exists, check if the item already exists
      final itemIndex = storeCarts[storeIndex]
          .items
          .indexWhere((item) => item.foodItem.id == event.foodItem.id);
      if (itemIndex != -1) {
        // Item exists, increment quantity by the provided quantity
        storeCarts[storeIndex].items[itemIndex].quantity += event.quantity;
      } else {
        // Item does not exist, add it with the provided quantity
        storeCarts[storeIndex]
            .items
            .add(CartItem(foodItem: event.foodItem, quantity: event.quantity));
      }
    } else {
      // Store does not exist, add it with the new item and provided quantity
      storeCarts.add(
        StoreCart(
          storeId: event.foodItem.storeId,
          storeName: event.foodItem.storeName,
          storeLogo: event.foodItem.storeLogo,
          items: [CartItem(foodItem: event.foodItem, quantity: event.quantity)],
        ),
      );
    }

    // Save to SharedPreferences
    await prefs.setString('cart',
        json.encode(storeCarts.map((store) => store.toJson()).toList()));
    emit(CartLoaded(storeCarts));
  }

  void _removeFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    if (cartJson == null) return;

    List<StoreCart> storeCarts = (json.decode(cartJson) as List)
        .map((e) => StoreCart.fromJson(e))
        .toList();

    // Find the store and item to remove
    for (var storeCart in storeCarts) {
      storeCart.items
          .removeWhere((item) => item.foodItem.id == event.foodItemId);
    }

    // Remove empty stores
    storeCarts.removeWhere((store) => store.items.isEmpty);

    // Save to SharedPreferences
    await prefs.setString('cart', json.encode(storeCarts));
    emit(CartLoaded(storeCarts));
  }

  void _decrementQuantity(
      DecrementQuantity event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    if (cartJson == null) return;

    List<StoreCart> storeCarts = (json.decode(cartJson) as List)
        .map((e) => StoreCart.fromJson(e))
        .toList();

    // Find the item to decrement
    for (var storeCart in storeCarts) {
      final itemIndex = storeCart.items
          .indexWhere((item) => item.foodItem.id == event.foodItemId);
      if (itemIndex != -1) {
        final cartItem = storeCart.items[itemIndex];
        if (cartItem.quantity > 1) {
          // Decrement quantity if greater than 1
          storeCart.items[itemIndex] =
              cartItem.copyWith(quantity: cartItem.quantity - 1);
        } else {
          // Remove item if quantity is 1
          storeCart.items.removeAt(itemIndex);
        }
        break; // Exit loop once the item is found
      }
    }

    // Remove empty stores
    // storeCarts.removeWhere((store) => store.items.isEmpty);

    // Save to SharedPreferences
    await prefs.setString('cart', json.encode(storeCarts));
    emit(CartLoaded(storeCarts));
  }

  void _clearCart(ClearCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    emit(CartLoaded([]));
  }

  void _clearStoreCart(ClearStoreCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    if (cartJson == null) return;

    List<StoreCart> storeCarts = (json.decode(cartJson) as List)
        .map((e) => StoreCart.fromJson(e))
        .toList();

    // Remove the store
    storeCarts.removeWhere((store) => store.storeId == event.storeId);

    // Save to SharedPreferences
    await prefs.setString('cart', json.encode(storeCarts));
    emit(CartLoaded(storeCarts));
  }

  void _loadCart(LoadCart event, Emitter<CartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    if (cartJson == null) {
      emit(CartLoaded([]));
    } else {
      List<StoreCart> storeCarts = (json.decode(cartJson) as List)
          .map((e) => StoreCart.fromJson(e))
          .toList();
      emit(CartLoaded(storeCarts));
    }
  }
}
