import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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

  const AddAddress(
      {required this.address, this.label, required this.isPrimary});

  @override
  List<Object?> get props => [address, label, isPrimary];
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

  AddAddressBloc(this._authRepository) : super(AddressInitial()) {
    on<AddAddress>(_onAddAddress);
  }

  Future<void> _onAddAddress(
      AddAddress event, Emitter<AddAddressState> emit) async {
    emit(AddressLoading());
    try {
      await _authRepository.saveAddress(
          address: event.address,
          label: event.label,
          isPrimary: event.isPrimary);
      emit(AddressAdded());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}
