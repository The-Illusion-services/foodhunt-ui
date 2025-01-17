import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

abstract class NewOrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNewOrders extends NewOrdersEvent {}

abstract class NewOrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewOrdersInitial extends NewOrdersState {}

class NewOrdersLoading extends NewOrdersState {}

class NewOrdersLoaded extends NewOrdersState {
  final List<dynamic> newOrders;

  NewOrdersLoaded(this.newOrders);

  @override
  List<Object?> get props => [newOrders];
}

class NewOrdersError extends NewOrdersState {
  final String message;

  NewOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class NewOrdersBloc extends Bloc<NewOrdersEvent, NewOrdersState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  NewOrdersBloc(this._restaurantRepository) : super(NewOrdersInitial()) {
    on<FetchNewOrders>(_onFetchNewOrders);
  }

  Future<void> _onFetchNewOrders(
      FetchNewOrders event, Emitter<NewOrdersState> emit) async {
    emit(NewOrdersLoading());

    var res = await authService.getRestaurantId();
    try {
      final newOrders = await _restaurantRepository.fetchNewOrders(
        restaurantId: res!, // "1"
      );

      print(newOrders);

      emit(NewOrdersLoaded(newOrders));
    } catch (e) {
      emit(NewOrdersError('Failed to load store overview.'));
    }
  }
}
