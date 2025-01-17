import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

abstract class OngoingOrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchOngoingOrders extends OngoingOrdersEvent {}

abstract class OngoingOrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OngoingOrdersInitial extends OngoingOrdersState {}

class OngoingOrdersLoading extends OngoingOrdersState {}

class OngoingOrdersLoaded extends OngoingOrdersState {
  final List<dynamic> ongoingOrders;

  OngoingOrdersLoaded(this.ongoingOrders);

  @override
  List<Object?> get props => [ongoingOrders];
}

class OngoingOrdersError extends OngoingOrdersState {
  final String message;

  OngoingOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class OngoingOrdersBloc extends Bloc<OngoingOrdersEvent, OngoingOrdersState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  OngoingOrdersBloc(this._restaurantRepository)
      : super(OngoingOrdersInitial()) {
    on<FetchOngoingOrders>(_onFetchOngoingOrders);
  }

  Future<void> _onFetchOngoingOrders(
      FetchOngoingOrders event, Emitter<OngoingOrdersState> emit) async {
    emit(OngoingOrdersLoading());
    var res = await authService.getRestaurantId();
    try {
      final ongoingOrders = await _restaurantRepository.fetchOngoingOrders(
        restaurantId: res!, // "1"
      );

      print(ongoingOrders);

      emit(OngoingOrdersLoaded(ongoingOrders));
    } catch (e) {
      emit(OngoingOrdersError('Failed to load store overview.'));
    }
  }
}
