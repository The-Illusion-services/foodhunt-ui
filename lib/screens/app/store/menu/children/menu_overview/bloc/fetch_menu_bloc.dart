import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class FetchMenuEvent extends Equatable {
  const FetchMenuEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllMenu extends FetchMenuEvent {
  const FetchAllMenu();

  @override
  List<Object?> get props => [];
}

class RefreshMenu extends FetchMenuEvent {
  const RefreshMenu();

  @override
  List<Object?> get props => [];
}

// States
abstract class FetchMenuState extends Equatable {
  const FetchMenuState();

  @override
  List<Object?> get props => [];
}

class FetchMenuInitial extends FetchMenuState {}

class FetchAllMenuLoading extends FetchMenuState {}

class FetchAllMenuSuccess extends FetchMenuState {
  final List<dynamic> menu;

  FetchAllMenuSuccess(this.menu);

  @override
  List<Object?> get props => [menu];
}

class FetchAllMenuFailure extends FetchMenuState {
  final String error;
  const FetchAllMenuFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class FetchMenuBloc extends Bloc<FetchMenuEvent, FetchMenuState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  FetchMenuBloc(
    this._restaurantRepository,
  ) : super(FetchMenuInitial()) {
    on<FetchAllMenu>(_fetchAllMenu);
    on<RefreshMenu>(_refreshMenu);
  }

  Future<void> _fetchAllMenu(
      FetchAllMenu event, Emitter<FetchMenuState> emit) async {
    emit(FetchAllMenuLoading());
    var res = await authService.getRestaurantId();

    try {
      final menu = await _restaurantRepository.fetchAllMenu(
        restaurantId: res!, // "1"
      );

      emit(FetchAllMenuSuccess(menu));
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(FetchAllMenuFailure(e.toString()));
    }
  }

  Future<void> _refreshMenu(
      RefreshMenu event, Emitter<FetchMenuState> emit) async {
    emit(FetchAllMenuLoading());
    var res = await authService.getRestaurantId();

    try {
      final menu = await _restaurantRepository.fetchAllMenu(
        restaurantId: res!, // "1"
      );
      emit(FetchAllMenuSuccess(menu));
    } catch (e) {
      emit(FetchAllMenuFailure('Failed to refresh menu categories'));
    }
  }
}
