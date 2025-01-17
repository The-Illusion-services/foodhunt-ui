class StoreCart {
  final String logoUrl;
  final String name;
  final int itemsCount;
  final String location;

  StoreCart({
    required this.logoUrl,
    required this.name,
    required this.itemsCount,
    required this.location,
  });
}

class CartItem {
  final String imageUrl;
  final String name;
  final String details;
  final double price;
  int quantity;

  CartItem({
    required this.imageUrl,
    required this.name,
    required this.details,
    required this.price,
    this.quantity = 1,
  });
}
