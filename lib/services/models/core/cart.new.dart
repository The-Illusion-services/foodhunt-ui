// models/cart_item.dart
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;
  final Map<String, dynamic>? additionalDetails;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.additionalDetails,
  });

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    int? quantity,
    Map<String, dynamic>? additionalDetails,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      additionalDetails: additionalDetails ?? this.additionalDetails,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, price, imageUrl, quantity, additionalDetails];
}
