import 'package:equatable/equatable.dart';

import '../../../../../services/models/core/cart.new.dart';
import '../../../../../services/models/core/store.new.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddItemToCart extends CartEvent {
  final Store store;
  final CartItem item;

  const AddItemToCart({required this.store, required this.item});

  @override
  List<Object?> get props => [store, item];
}

class RemoveItemFromCart extends CartEvent {
  final Store store;
  final CartItem item;

  const RemoveItemFromCart({required this.store, required this.item});

  @override
  List<Object?> get props => [store, item];
}

class ClearStoreCart extends CartEvent {
  final Store store;

  const ClearStoreCart({required this.store});

  @override
  List<Object?> get props => [store];
}

class ClearEntireCart extends CartEvent {}

class LoadCartFromStorage extends CartEvent {}
