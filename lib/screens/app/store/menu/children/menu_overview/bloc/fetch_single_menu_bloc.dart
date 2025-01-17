import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class FetchSingleMenuEvent extends Equatable {
  const FetchSingleMenuEvent();

  @override
  List<Object?> get props => [];
}

class FetchSingleMenu extends FetchSingleMenuEvent {
  final String menuId;

  const FetchSingleMenu({required this.menuId});

  @override
  List<Object?> get props => [menuId];
}

class RefreshMenu extends FetchSingleMenuEvent {
  final String menuId;

  const RefreshMenu({required this.menuId});

  @override
  List<Object?> get props => [menuId];
}

// States
abstract class FetchSingleMenuState extends Equatable {
  const FetchSingleMenuState();

  @override
  List<Object?> get props => [];
}

class FetchSingleMenuInitial extends FetchSingleMenuState {}

class FetchSingleMenuLoading extends FetchSingleMenuState {}

class FetchSingleMenuSuccess extends FetchSingleMenuState {
  final dynamic menu;

  FetchSingleMenuSuccess(this.menu);

  @override
  List<Object?> get props => [menu];
}

class FetchSingleMenuFailure extends FetchSingleMenuState {
  final String error;
  const FetchSingleMenuFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class FetchSingleMenuBloc
    extends Bloc<FetchSingleMenuEvent, FetchSingleMenuState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  FetchSingleMenuBloc(
    this._restaurantRepository,
  ) : super(FetchSingleMenuInitial()) {
    on<FetchSingleMenu>(_fetchSingleMenu);
    on<RefreshMenu>(_refreshMenu);
  }

  Future<void> _fetchSingleMenu(
      FetchSingleMenu event, Emitter<FetchSingleMenuState> emit) async {
    emit(FetchSingleMenuLoading());
    try {
      final menu =
          await _restaurantRepository.fetchSingleMenu(menuId: event.menuId);

      emit(FetchSingleMenuSuccess(menu));
    } catch (e) {
      emit(FetchSingleMenuFailure(e.toString()));
    }
  }

  Future<void> _refreshMenu(
      RefreshMenu event, Emitter<FetchSingleMenuState> emit) async {
    emit(FetchSingleMenuLoading());
    try {
      final menu =
          await _restaurantRepository.fetchSingleMenu(menuId: event.menuId);

      emit(FetchSingleMenuSuccess(menu));
    } catch (e) {
      emit(FetchSingleMenuFailure('Failed to refresh menu'));
    }
  }
}
