import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class EditDishEvent extends Equatable {
  const EditDishEvent();

  @override
  List<Object?> get props => [];
}

class SubmitDishDetails extends EditDishEvent {
  final String name;
  final String description;
  final String price;
  final bool isAvailable;
  final File dishImage;
  final String dishId;

  const SubmitDishDetails(
      {required this.name,
      required this.price,
      required this.description,
      required this.isAvailable,
      required this.dishImage,
      required this.dishId});

  @override
  List<Object?> get props => [name, description, price, isAvailable, dishImage];
}

// States
abstract class EditDishState extends Equatable {
  const EditDishState();

  @override
  List<Object?> get props => [];
}

class EditDishInitial extends EditDishState {}

class EditDishLoading extends EditDishState {}

class EditDishSuccess extends EditDishState {}

class EditDishFailure extends EditDishState {
  final String error;
  const EditDishFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class EditDishBloc extends Bloc<EditDishEvent, EditDishState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  EditDishBloc(
    this._restaurantRepository,
  ) : super(EditDishInitial()) {
    on<SubmitDishDetails>(_submitDishDetails);
  }

  Future<void> _submitDishDetails(
      SubmitDishDetails event, Emitter<EditDishState> emit) async {
    emit(EditDishLoading());
    try {
      await _restaurantRepository.editDish(
          name: event.name,
          description: event.description,
          price: event.price,
          dishId: event.dishId,
          dishImage: event.dishImage,
          isAvailable: event.isAvailable);

      emit(EditDishSuccess());
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(EditDishFailure(e.toString()));
    }
  }
}
