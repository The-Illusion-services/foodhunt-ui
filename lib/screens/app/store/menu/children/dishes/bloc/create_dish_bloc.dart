import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class CreateDishEvent extends Equatable {
  const CreateDishEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDishDetails extends CreateDishEvent {
  final String name;
  final String description;
  final String price;
  final bool isAvailable;
  final File dishImage;
  final String menuId;

  const SubmitDishDetails(
      {required this.name,
      required this.price,
      required this.description,
      required this.isAvailable,
      required this.dishImage,
      required this.menuId});

  @override
  List<Object?> get props => [name, description, price, isAvailable, dishImage];
}

// States
abstract class CreateDishState extends Equatable {
  const CreateDishState();

  @override
  List<Object?> get props => [];
}

class CreateDishInitial extends CreateDishState {}

class CreateDishLoading extends CreateDishState {}

class CreateDishSuccess extends CreateDishState {}

class CreateDishFailure extends CreateDishState {
  final String error;
  const CreateDishFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class CreateDishBloc extends Bloc<CreateDishEvent, CreateDishState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  CreateDishBloc(
    this._restaurantRepository,
  ) : super(CreateDishInitial()) {
    on<SubmitDishDetails>(_submitDishDetails);
  }

  Future<void> _submitDishDetails(
      SubmitDishDetails event, Emitter<CreateDishState> emit) async {
    emit(CreateDishLoading());
    try {
      await _restaurantRepository.createDish(
          name: event.name,
          description: event.description,
          price: event.price,
          menuId: event.menuId,
          dishImage: event.dishImage,
          isAvailable: event.isAvailable);

      emit(CreateDishSuccess());
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(CreateDishFailure(e.toString()));
    }
  }
}
