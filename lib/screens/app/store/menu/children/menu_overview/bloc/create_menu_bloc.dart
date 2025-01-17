import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class CreateMenuEvent extends Equatable {
  const CreateMenuEvent();

  @override
  List<Object?> get props => [];
}

class SubmitMenuDetails extends CreateMenuEvent {
  final String name;
  final String description;
  final File? menuImage;

  const SubmitMenuDetails(
      {required this.name, required this.description, this.menuImage});

  @override
  List<Object?> get props => [name, description, menuImage];
}

// States
abstract class CreateMenuState extends Equatable {
  const CreateMenuState();

  @override
  List<Object?> get props => [];
}

class CreateMenuInitial extends CreateMenuState {}

class CreateMenuLoading extends CreateMenuState {}

class CreateMenuSuccess extends CreateMenuState {}

class CreateMenuFailure extends CreateMenuState {
  final String error;
  const CreateMenuFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class CreateMenuBloc extends Bloc<CreateMenuEvent, CreateMenuState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  CreateMenuBloc(
    this._restaurantRepository,
  ) : super(CreateMenuInitial()) {
    on<SubmitMenuDetails>(_submitMenuDetails);
  }

  Future<void> _submitMenuDetails(
      SubmitMenuDetails event, Emitter<CreateMenuState> emit) async {
    emit(CreateMenuLoading());

    var res = await authService.getRestaurantId();

    try {
      await _restaurantRepository.createMenu(
          name: event.name,
          description: event.description,
          restaurant: res!, // "1",
          menuImage: event.menuImage);

      emit(CreateMenuSuccess());
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(CreateMenuFailure(e.toString()));
    }
  }
}
