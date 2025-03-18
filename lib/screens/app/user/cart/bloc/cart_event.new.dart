import 'package:food_hunt/services/models/core/cart.recent.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class AddToCart extends CartEvent {
  final FoodItem foodItem;
  final int quantity; // Add quantity parameter

  AddToCart(this.foodItem, {this.quantity = 1}); // Default quantity is 1

  @override
  List<Object?> get props => [foodItem, quantity];
}

class RemoveFromCart extends CartEvent {
  final String foodItemId;

  RemoveFromCart(this.foodItemId);

  @override
  List<Object?> get props => [foodItemId];
}

class DecrementQuantity extends CartEvent {
  final String foodItemId;

  DecrementQuantity(this.foodItemId);

  @override
  List<Object?> get props => [foodItemId];
}

class ClearCart extends CartEvent {
  @override
  List<Object?> get props => [];
}

class ClearStoreCart extends CartEvent {
  final String storeId;

  ClearStoreCart(this.storeId);

  @override
  List<Object?> get props => [storeId];
}

class LoadCart extends CartEvent {
  @override
  List<Object?> get props => [];
}
