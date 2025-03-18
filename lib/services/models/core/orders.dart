class Order {
  final String id;
  final String storeName;
  final String storeImage;
  final int itemCount;
  final double totalAmount;
  final DateTime placedAt;
  final OrderStatus status;
  final Map<String, dynamic> restaurant;

  Order(
      {required this.id,
      required this.storeName,
      required this.storeImage,
      required this.itemCount,
      required this.totalAmount,
      required this.placedAt,
      required this.status,
      required this.restaurant});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'].toString(),
      storeName: json['restaurant_name'] ?? '',
      storeImage: json['restaurant_image'] ?? '',
      itemCount: json['items'].length ?? 0,
      totalAmount: double.parse((json['total_price'] ?? '0').toString()),
      placedAt: DateTime.parse(
          json['ordered_at'] ?? DateTime.now().toIso8601String()),
      status: _parseOrderStatus(json['status']),
      restaurant: (json['restaurant']),
    );
  }

  static OrderStatus _parseOrderStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'delivering':
        return OrderStatus.delivering;
      case 'completed':
        return OrderStatus.completed;
      case 'rejected':
        return OrderStatus.rejected;
      default:
        return OrderStatus.pending;
    }
  }
}

enum OrderStatus { pending, processing, delivering, completed, rejected }
