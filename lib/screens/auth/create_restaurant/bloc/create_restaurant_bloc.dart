import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Events
abstract class CreateStoreEvent extends Equatable {
  const CreateStoreEvent();

  @override
  List<Object?> get props => [];
}

class SubmitStoreDetails extends CreateStoreEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String description;
  final String storeType;
  final String address;
  final File? profileImage;
  final File? headerImage;

  const SubmitStoreDetails(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.description,
      required this.storeType,
      required this.address,
      this.profileImage,
      this.headerImage});

  @override
  List<Object?> get props => [
        name,
        email,
        phoneNumber,
        description,
        storeType,
        address,
        profileImage,
        headerImage
      ];
}

// States
abstract class CreateStoreState extends Equatable {
  const CreateStoreState();

  @override
  List<Object?> get props => [];
}

class CreateStoreInitial extends CreateStoreState {}

class CreateStoreLoading extends CreateStoreState {}

class CreateStoreSuccess extends CreateStoreState {}

class CreateStoreFailure extends CreateStoreState {
  final String error;
  const CreateStoreFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class CreateStoreBloc extends Bloc<CreateStoreEvent, CreateStoreState> {
  final AuthRepository _authRepository;
  final AuthService authService = AuthService();

  CreateStoreBloc(
    this._authRepository,
  ) : super(CreateStoreInitial()) {
    on<SubmitStoreDetails>(_submitStoreDetails);
  }

  Future<void> _submitStoreDetails(
      SubmitStoreDetails event, Emitter<CreateStoreState> emit) async {
    emit(CreateStoreLoading());
    try {
      final response = await _authRepository.createStore(
        name: event.name,
        email: event.email,
        phone: event.phoneNumber,
        description: event.description,
        address: event.address,
        storeType: event.storeType,
        profileImage: event.profileImage,
        headerImage: event.headerImage,
      );

      authService.setRestaurantId(response['restaurant']['id'].toString());

      emit(CreateStoreSuccess());
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(CreateStoreFailure(e.toString()));
    }
  }
}
