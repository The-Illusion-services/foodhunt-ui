import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/services/models/core/orders.dart';
import 'package:food_hunt/services/repositories/orders_repository.dart';

// orders_state.dart
abstract class OrdersState {
  const OrdersState();
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> ongoingOrders;
  final List<Order> historyOrders;

  OrdersLoaded({
    required this.ongoingOrders,
    required this.historyOrders,
  });
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);
}

// orders_event.dart
abstract class OrdersEvent {
  const OrdersEvent();
}

class LoadOrders extends OrdersEvent {}

class RefreshOrders extends OrdersEvent {}

class ReorderPlaced extends OrdersEvent {
  final String originalOrderId;

  ReorderPlaced(this.originalOrderId);
}

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository ordersRepository;

  OrdersBloc(this.ordersRepository) : super(OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<RefreshOrders>(_onRefreshOrders);
    on<ReorderPlaced>(_onReorderPlaced);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(OrdersLoading());
      final orders = await ordersRepository.getAllOrders();

      // Filter orders based on status
      final ongoingOrders = orders
          .where((order) =>
              order.status == OrderStatus.pending ||
              order.status == OrderStatus.processing ||
              order.status == OrderStatus.delivering)
          .toList();

      final historyOrders = orders
          .where((order) =>
              order.status == OrderStatus.completed ||
              order.status == OrderStatus.rejected)
          .toList();

      emit(OrdersLoaded(
        ongoingOrders: ongoingOrders,
        historyOrders: historyOrders,
      ));
    } catch (e) {
      emit(OrdersError('Failed to load orders: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final orders = await ordersRepository.getAllOrders();

      final ongoingOrders = orders
          .where((order) =>
              order.status == OrderStatus.pending ||
              order.status == OrderStatus.processing ||
              order.status == OrderStatus.delivering)
          .toList();

      final historyOrders = orders
          .where((order) =>
              order.status == OrderStatus.completed ||
              order.status == OrderStatus.rejected)
          .toList();

      emit(OrdersLoaded(
        ongoingOrders: ongoingOrders,
        historyOrders: historyOrders,
      ));
    } catch (e) {
      emit(OrdersError('Failed to refresh orders: ${e.toString()}'));
    }
  }

  Future<void> _onReorderPlaced(
    ReorderPlaced event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      // await ordersRepository.reorder(event.originalOrderId);
      add(RefreshOrders());
    } catch (e) {
      emit(OrdersError('Failed to place reorder: ${e.toString()}'));
    }
  }
}
