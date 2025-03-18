import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/services/models/core/cart.recent.dart';
import 'dart:async';

import 'package:food_hunt/services/repositories/orders_repository.dart';

abstract class OrderEvent {
  const OrderEvent();
}

class CreateOrder extends OrderEvent {
  final String paymentReference;
  final String storeId;
  final String storeName;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double total;
  // final String deliveryAddress;
  final int addressId;
  final String? deliveryNotes;

  const CreateOrder({
    required this.paymentReference,
    required this.storeId,
    required this.storeName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.total,
    // required this.deliveryAddress,
    required this.addressId,
    this.deliveryNotes,
  });
}

// order_state.dart
abstract class CreateOrderState {
  const CreateOrderState();
}

class OrderInitial extends CreateOrderState {}

class OrderLoading extends CreateOrderState {}

class OrderCreated extends CreateOrderState {
  final int orderId;
  // final String paymentReference;

  const OrderCreated({
    required this.orderId,
    // required this.paymentReference,
  });
}

class CreateOrderError extends CreateOrderState {
  final String message;

  const CreateOrderError(this.message);
}

class CreateOrderBloc extends Bloc<OrderEvent, CreateOrderState> {
  final OrdersRepository _orderRepository;

  CreateOrderBloc(this._orderRepository) : super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
      CreateOrder event, Emitter<CreateOrderState> emit) async {
    try {
      emit(OrderLoading());

      final order = await _orderRepository.createOrder(
        paymentReference: event.paymentReference,
        storeId: event.storeId,
        items: event.items,
        addressId: event.addressId,
        amount: event.total,
        // addressId: event.deliveryAddress,

        // storeName: event.storeName,

        // subtotal: event.subtotal,
        // deliveryFee: event.deliveryFee,
        // serviceFee: event.serviceFee,
        // total: event.total,
        // deliveryAddress: event.deliveryAddress,
        // deliveryNotes: event.deliveryNotes,
      );

      print(order);

      emit(OrderCreated(
        orderId: order['order_id'],
      ));
    } catch (e) {
      emit(CreateOrderError('Failed to create order: ${e.toString()}'));
    }
  }
}

// order_repository.dart
// class OrderRepository {
//   final ApiClient apiClient;

//   OrderRepository({required this.apiClient});

//   Future<OrderResponse> createOrder({
//     required String paymentReference,
//     required String storeId,
//     required String storeName,
//     required List<Map<String, dynamic>> items,
//     required double subtotal,
//     required double deliveryFee,
//     required double serviceFee,
//     required double total,
//     required String deliveryAddress,
//     String? deliveryNotes,
//   }) async {
//     try {
//       final response = await apiClient.post(
//         '/orders',
//         body: {
//           'payment_reference': paymentReference,
//           'store_id': storeId,
//           'store_name': storeName,
//           'items': items,
//           'subtotal': subtotal,
//           'delivery_fee': deliveryFee,
//           'service_fee': serviceFee,
//           'total': total,
//           'delivery_address': deliveryAddress,
//           'delivery_notes': deliveryNotes,
//         },
//       );

//       return OrderResponse.fromJson(response);
//     } catch (e) {
//       throw Exception('Failed to create order: ${e.toString()}');
//     }
//   }
// }

// order_response.dart
class OrderResponse {
  final String orderId;
  final String paymentReference;
  final String status;
  final DateTime createdAt;

  OrderResponse({
    required this.orderId,
    required this.paymentReference,
    required this.status,
    required this.createdAt,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['order_id'],
      paymentReference: json['payment_reference'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
