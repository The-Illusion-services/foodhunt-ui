import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

abstract class PopularMealsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPopularMeals extends PopularMealsEvent {}

abstract class PopularMealsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularMealsInitial extends PopularMealsState {}

class PopularMealsLoading extends PopularMealsState {}

class PopularMealsLoaded extends PopularMealsState {
  final List<dynamic> popularMeals;

  PopularMealsLoaded(this.popularMeals);

  @override
  List<Object?> get props => [popularMeals];
}

class PopularMealsError extends PopularMealsState {
  final String message;

  PopularMealsError(this.message);

  @override
  List<Object?> get props => [message];
}

class PopularMealsBloc extends Bloc<PopularMealsEvent, PopularMealsState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  PopularMealsBloc(this._restaurantRepository) : super(PopularMealsInitial()) {
    on<FetchPopularMeals>(_onFetchPopularMeals);
  }

  Future<void> _onFetchPopularMeals(
      FetchPopularMeals event, Emitter<PopularMealsState> emit) async {
    emit(PopularMealsLoading());
    var res = await authService.getRestaurantId();

    try {
      final popularMeals = await _restaurantRepository.fetchPopularDishes(
        restaurantId: res!, // "1"
      );

      print(popularMeals);

      emit(PopularMealsLoaded(popularMeals));
    } catch (e) {
      emit(PopularMealsError('Failed to load store overview.'));
    }
  }
}
