// Bloc Implementation

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/services/models/core/orders.dart';
import 'package:food_hunt/services/repositories/orders_repository.dart';

// Events
abstract class OrderDetailsEvent {}

class FetchOrder extends OrderDetailsEvent {
  final String orderId;
  FetchOrder(this.orderId);
}

// States
abstract class OrderDetailsState {}

class OrderLoading extends OrderDetailsState {}

class OrderLoaded extends OrderDetailsState {
  final Order order;
  OrderLoaded(this.order);
}

class OrderError extends OrderDetailsState {
  final String message;
  OrderError(this.message);
}

// Bloc
class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrdersRepository orderRepository;

  OrderDetailsBloc(this.orderRepository) : super(OrderLoading()) {
    on<FetchOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        final order =
            await orderRepository.getOrderById(orderId: event.orderId);
        emit(OrderLoaded(order));
      } catch (e) {
        emit(OrderError("Failed to fetch order details"));
      }
    });
  }
}
