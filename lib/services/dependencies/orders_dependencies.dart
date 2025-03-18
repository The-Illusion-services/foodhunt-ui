import 'package:food_hunt/core/config/url.dart';
import 'package:food_hunt/screens/app/user/checkout/bloc/checkout_bloc.dart';
import 'package:food_hunt/screens/app/user/orders/bloc/orders_bloc.dart';
import 'package:food_hunt/screens/app/user/orders/bloc/single_order_bloc.dart';
import 'package:food_hunt/services/api.dart';
import 'package:food_hunt/services/repositories/orders_repository.dart';

class OrdersDependencies {
  static final apiService = ApiService(baseUrl: baseUrl);

  static OrdersRepository get ordersRepository => OrdersRepository(
        apiService,
      );

  static OrdersBloc get ordersBloc =>
      OrdersBloc(ordersRepository)..add(LoadOrders());

  static OrderDetailsBloc get getOrderDetailsBloc =>
      OrderDetailsBloc(ordersRepository);

  static CreateOrderBloc get createOrdersBloc =>
      CreateOrderBloc(ordersRepository);
}
