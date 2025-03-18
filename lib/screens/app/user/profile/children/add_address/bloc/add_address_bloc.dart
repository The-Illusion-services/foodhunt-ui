import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/services/address_service.dart';
import 'package:food_hunt/services/models/core/address.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Event
abstract class AddAddressEvent extends Equatable {
  const AddAddressEvent();

  @override
  List<Object?> get props => [];
}

class AddAddress extends AddAddressEvent {
  final String address;
  final String? label;
  final bool isPrimary;
  final dynamic longitude;
  final dynamic latitude;
  final String? plusCode;

  const AddAddress(
      {required this.address,
      this.label,
      required this.isPrimary,
      required this.latitude,
      required this.longitude,
      this.plusCode});

  @override
  List<Object?> get props =>
      [address, label, isPrimary, longitude, latitude, plusCode];
}

// State
abstract class AddAddressState extends Equatable {
  const AddAddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddAddressState {}

class AddressLoading extends AddAddressState {}

class AddressAdded extends AddAddressState {
  const AddressAdded();

  @override
  List<Object?> get props => [];
}

class AddressError extends AddAddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  final AuthRepository _authRepository;
  final AddressService _addressService;

  AddAddressBloc(this._authRepository, this._addressService)
      : super(AddressInitial()) {
    on<AddAddress>(_onAddAddress);
  }

  Future<void> _onAddAddress(
      AddAddress event, Emitter<AddAddressState> emit) async {
    emit(AddressLoading());

    try {
      final address = await _authRepository.saveAddress(
          address: event.address,
          label: event.label,
          longitude: event.longitude,
          latitude: event.latitude,
          isPrimary: event.isPrimary,
          plusCode: event.plusCode);

      final newAddress = UserAddress(
          id: address['id'],
          address: event.address,
          label: event.label,
          longitude: event.longitude,
          latitude: event.latitude,
          primary: event.isPrimary,
          plusCode: event.plusCode);

      await _addressService.addAddress(newAddress);

      emit(AddressAdded());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}
