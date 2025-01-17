import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class FetchMenuDishesEvent extends Equatable {
  const FetchMenuDishesEvent();

  @override
  List<Object?> get props => [];
}

class FetchMenuDishes extends FetchMenuDishesEvent {
  final String menuId;
  const FetchMenuDishes({required this.menuId});

  @override
  List<Object?> get props => [menuId];
}

// States
abstract class FetchMenuDishesState extends Equatable {
  const FetchMenuDishesState();

  @override
  List<Object?> get props => [];
}

class FetchMenuDishesInitial extends FetchMenuDishesState {}

class FetchMenuDishesLoading extends FetchMenuDishesState {}

class FetchMenuDishesSuccess extends FetchMenuDishesState {
  final List<dynamic> dishes;

  FetchMenuDishesSuccess(this.dishes);

  @override
  List<Object?> get props => [dishes];
}

class FetchMenuDishesFailure extends FetchMenuDishesState {
  final String error;
  const FetchMenuDishesFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class FetchMenuDishesBloc
    extends Bloc<FetchMenuDishesEvent, FetchMenuDishesState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  FetchMenuDishesBloc(
    this._restaurantRepository,
  ) : super(FetchMenuDishesInitial()) {
    on<FetchMenuDishes>(_fetchMenuDishes);
  }

  Future<void> _fetchMenuDishes(
      FetchMenuDishes event, Emitter<FetchMenuDishesState> emit) async {
    emit(FetchMenuDishesLoading());
    try {
      final dishes =
          await _restaurantRepository.fetchMenuDishes(menuId: event.menuId);

      emit(FetchMenuDishesSuccess(dishes));
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(FetchMenuDishesFailure(e.toString()));
    }
  }
}
