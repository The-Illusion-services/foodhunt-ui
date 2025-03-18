// models/store.dart
import 'package:equatable/equatable.dart';
import 'package:food_hunt/services/models/core/cart.new.dart';

class Store extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final List<CartItem> items;

  const Store({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.items,
  });

  double get totalPrice =>
      items.fold(0, (total, item) => total + (item.price * item.quantity));
  int get totalItems => items.fold(0, (total, item) => total + item.quantity);

  Store copyWith({
    String? id,
    String? name,
    String? logoUrl,
    List<CartItem>? items,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, name, logoUrl, items];
}
