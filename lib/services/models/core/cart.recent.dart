class StoreCart {
  final String storeId;
  final String storeName;
  final String storeLogo;
  final List<CartItem> items;

  StoreCart({
    required this.storeId,
    required this.storeName,
    required this.storeLogo,
    required this.items,
  });

  // Convert StoreCart to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'storeLogo': storeLogo,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Factory method to create a StoreCart from JSON
  factory StoreCart.fromJson(Map<String, dynamic> json) {
    return StoreCart(
      storeId: json['storeId'],
      storeName: json['storeName'],
      storeLogo: json['storeLogo'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}

class CartItem {
  final FoodItem foodItem;
  int quantity;

  CartItem({
    required this.foodItem,
    required this.quantity,
  });

  // Convert CartItem to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
    };
  }

  // Factory method to create a CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      foodItem: FoodItem.fromJson(json['foodItem']),
      quantity: json['quantity'],
    );
  }

  CartItem copyWith({
    FoodItem? foodItem,
    int? quantity,
  }) {
    return CartItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final String? dishImage;
  final String? description;
  final double price;
  final String storeId;
  final String storeName;
  final String storeLogo;

  FoodItem(
      {required this.id,
      required this.name,
      required this.price, // Add price to the constructor
      required this.storeId,
      required this.storeName,
      required this.storeLogo,
      this.dishImage,
      this.description});

  // Convert FoodItem to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price, // Include price in JSON
      'storeId': storeId,
      'storeName': storeName,
      'storeLogo': storeLogo,
      'dishImage': dishImage, 'description': description,
    };
  }

  // Factory method to create a FoodItem from JSON
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      price: json['price'], // Parse price from JSON
      storeId: json['storeId'],
      storeName: json['storeName'],
      dishImage: json['dishImage'],
      storeLogo: json['storeLogo'],
      description: json['description'],
    );
  }
}
