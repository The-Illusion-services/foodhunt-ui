import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class FetchDishEvent extends Equatable {
  const FetchDishEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllDishes extends FetchDishEvent {
  const FetchAllDishes();

  @override
  List<Object?> get props => [];
}

class FetchSingleDish extends FetchDishEvent {
  const FetchSingleDish();

  @override
  List<Object?> get props => [];
}

// States
abstract class FetchDishState extends Equatable {
  const FetchDishState();

  @override
  List<Object?> get props => [];
}

class FetchDishInitial extends FetchDishState {}

class FetchAllDishLoading extends FetchDishState {}

class FetchAllDishSuccess extends FetchDishState {
  final List<dynamic> dishes;

  const FetchAllDishSuccess({required this.dishes});

  @override
  List<Object?> get props => [dishes];
}

class FetchAllDishFailure extends FetchDishState {
  final String error;
  const FetchAllDishFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class FetchSingleDishLoading extends FetchDishState {}

class FetchSingleDishSuccess extends FetchDishState {}

class FetchSingleDishFailure extends FetchDishState {
  final String error;
  const FetchSingleDishFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class FetchDishBloc extends Bloc<FetchDishEvent, FetchDishState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  FetchDishBloc(
    this._restaurantRepository,
  ) : super(FetchDishInitial()) {
    on<FetchAllDishes>(_fetchAllDishes);
    on<FetchSingleDish>(_fetchSingleDish);
  }

  Future<void> _fetchAllDishes(
      FetchAllDishes event, Emitter<FetchDishState> emit) async {
    emit(FetchAllDishLoading());
    var res = await authService.getRestaurantId();

    try {
      final dishes = await _restaurantRepository.fetchAllDishes(
        restaurantId: res!, // "1"
      );

      emit(FetchAllDishSuccess(dishes: dishes));
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(FetchAllDishFailure(e.toString()));
    }
  }

  Future<void> _fetchSingleDish(
      FetchSingleDish event, Emitter<FetchDishState> emit) async {
    emit(FetchSingleDishLoading());
    try {
      await _restaurantRepository.fetchSingleDish();

      emit(FetchSingleDishSuccess());
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(FetchSingleDishFailure(e.toString()));
    }
  }
}
