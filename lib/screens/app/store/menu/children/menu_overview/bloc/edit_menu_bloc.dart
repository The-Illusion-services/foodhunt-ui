import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class EditMenuEvent extends Equatable {
  const EditMenuEvent();

  @override
  List<Object?> get props => [];
}

class SubmitMenuDetails extends EditMenuEvent {
  final String name;
  final String description;
  final File? menuImage;
  final String menuId;

  const SubmitMenuDetails({
    required this.name,
    required this.description,
    required this.menuId,
    this.menuImage,
  });

  @override
  List<Object?> get props => [name, description, menuImage, menuId];
}

// States
abstract class EditMenuState extends Equatable {
  const EditMenuState();

  @override
  List<Object?> get props => [];
}

class EditMenuInitial extends EditMenuState {}

class EditMenuLoading extends EditMenuState {}

class EditMenuSuccess extends EditMenuState {}

class EditMenuFailure extends EditMenuState {
  final String error;
  const EditMenuFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class EditMenuBloc extends Bloc<EditMenuEvent, EditMenuState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  EditMenuBloc(
    this._restaurantRepository,
  ) : super(EditMenuInitial()) {
    on<SubmitMenuDetails>(_submitMenuDetails);
  }

  Future<void> _submitMenuDetails(
      SubmitMenuDetails event, Emitter<EditMenuState> emit) async {
    emit(EditMenuLoading());

    var res = await authService.getRestaurantId();
    print(res);

    final prefs = await await SharedPreferences.getInstance();

    print(await prefs.getString("restaurantId"));

    try {
      await _restaurantRepository.updateMenu(
          name: event.name,
          description: event.description,
          restaurant: res!, //"1",
          menuImage: event.menuImage,
          menuId: event.menuId);

      emit(EditMenuSuccess());
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(EditMenuFailure(e.toString()));
    }
  }
}
