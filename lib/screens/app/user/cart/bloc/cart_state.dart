import 'package:equatable/equatable.dart';
import 'package:food_hunt/services/models/core/store.new.dart';

abstract class CartState extends Equatable {
  final List<Store> stores;

  const CartState({this.stores = const []});

  @override
  List<Object?> get props => [stores];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  const CartLoaded({required List<Store> stores}) : super(stores: stores);
}

class CartError extends CartState {
  final String errorMessage;

  const CartError({required this.errorMessage, List<Store> stores = const []})
      : super(stores: stores);

  @override
  List<Object?> get props => [errorMessage, stores];
}
