import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';
// import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class UpdateStoreDetailsEvent extends Equatable {
  const UpdateStoreDetailsEvent();

  @override
  List<Object> get props => [];
}

class UpdateStoreProfile extends UpdateStoreDetailsEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String description;
  final String storeType;
  final String address;
  final File? profileImage;
  final File? headerImage;

  const UpdateStoreProfile(
      {required this.name,
      required this.description,
      required this.address,
      required this.email,
      required this.phoneNumber,
      required this.storeType,
      this.profileImage,
      this.headerImage});

  @override
  List<Object> get props => [name, description, address, email, phoneNumber];
}

// States
abstract class UpdateStoreDetailsState extends Equatable {
  const UpdateStoreDetailsState();

  @override
  List<Object> get props => [];
}

class StoreDetailsInitial extends UpdateStoreDetailsState {}

class StoreDetailsUpdating extends UpdateStoreDetailsState {}

class StoreDetailsUpdated extends UpdateStoreDetailsState {}

class StoreDetailsUpdateError extends UpdateStoreDetailsState {
  final String message;

  const StoreDetailsUpdateError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class UpdateStoreDetailsBloc
    extends Bloc<UpdateStoreDetailsEvent, UpdateStoreDetailsState> {
  final AuthRepository _authRepository;
  final AuthService authService = AuthService();

  UpdateStoreDetailsBloc(this._authRepository) : super(StoreDetailsInitial()) {
    on<UpdateStoreProfile>(_onUpdateStoreProfile);
  }

  Future<void> _onUpdateStoreProfile(
      UpdateStoreProfile event, Emitter<UpdateStoreDetailsState> emit) async {
    emit(StoreDetailsUpdating());
    // var res = await authService.getRestaurantId();

    try {
      await _authRepository.updateStoreProfile(
        name: event.name,
        email: event.email,
        phone: event.phoneNumber,
        description: event.description,
        address: event.address,
        storeType: event.storeType,
        profileImage: event.profileImage,
        headerImage: event.headerImage,
      );

      emit(StoreDetailsUpdated());
    } catch (e) {
      emit(StoreDetailsUpdateError(e.toString()));
    }
  }
}
