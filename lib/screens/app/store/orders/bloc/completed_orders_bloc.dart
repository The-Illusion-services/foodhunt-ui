import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

abstract class CompletedOrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCompletedOrders extends CompletedOrdersEvent {}

abstract class CompletedOrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CompletedOrdersInitial extends CompletedOrdersState {}

class CompletedOrdersLoading extends CompletedOrdersState {}

class CompletedOrdersLoaded extends CompletedOrdersState {
  final List<dynamic> completedOrders;

  CompletedOrdersLoaded(this.completedOrders);

  @override
  List<Object?> get props => [completedOrders];
}

class CompletedOrdersError extends CompletedOrdersState {
  final String message;

  CompletedOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class CompletedOrdersBloc
    extends Bloc<CompletedOrdersEvent, CompletedOrdersState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  CompletedOrdersBloc(this._restaurantRepository)
      : super(CompletedOrdersInitial()) {
    on<FetchCompletedOrders>(_onFetchCompletedOrders);
  }

  Future<void> _onFetchCompletedOrders(
      FetchCompletedOrders event, Emitter<CompletedOrdersState> emit) async {
    emit(CompletedOrdersLoading());
    var res = await authService.getRestaurantId();
    try {
      final completedOrders = await _restaurantRepository.fetchCompletedOrders(
        restaurantId: res!, // "1"
      );

      print(completedOrders);

      emit(CompletedOrdersLoaded(completedOrders));
    } catch (e) {
      emit(CompletedOrdersError('Failed to load store overview.'));
    }
  }
}
