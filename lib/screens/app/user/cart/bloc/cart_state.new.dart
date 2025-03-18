import 'package:food_hunt/services/models/core/cart.recent.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartState {
  final List<StoreCart> storeCarts;

  CartLoaded(this.storeCarts);

  @override
  List<Object?> get props => [storeCarts];
}
