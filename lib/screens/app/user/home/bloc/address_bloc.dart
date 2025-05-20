import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/address_service.dart';
import 'package:food_hunt/services/models/core/address.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

abstract class UserAddressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserAddress extends UserAddressEvent {
  FetchUserAddress();
}

class LoadAddressesFromPrefs extends UserAddressEvent {}

abstract class UserAddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserAddressInitial extends UserAddressState {}

class UserAddressLoading extends UserAddressState {}

class UserAddressLoaded extends UserAddressState {
  final List<UserAddress> addresses;

  UserAddressLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class UserAddressError extends UserAddressState {
  final String message;

  UserAddressError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserAddressBloc extends Bloc<UserAddressEvent, UserAddressState> {
  final AuthRepository _authRepository;
  final AddressService _addressService;

  final AuthService authService = AuthService();

  UserAddressBloc(this._authRepository, this._addressService)
      : super(UserAddressInitial()) {
    on<FetchUserAddress>(_onFetchUserAddress);
    on<LoadAddressesFromPrefs>(_onLoadAddressesFromPrefs);
  }

  Future<void> _onFetchUserAddress(
      FetchUserAddress event, Emitter<UserAddressState> emit) async {
    emit(UserAddressLoading());
    try {
      print("SYART");
      final addresses = await _addressService.loadAddresses();
      print("1");

      if (addresses.isNotEmpty) {
        print("2");

        emit(UserAddressLoaded(addresses));
        print("3");
      } else {
        // Otherwise, fetch addresses from the repository
        final addresses = await _authRepository.getUserAddresses();
        print("4");

        await _addressService.addAddresses(addresses);
        print("5");

        emit(UserAddressLoaded(addresses));
      }
    } catch (e) {
      print(e);
      emit(UserAddressError(e.toString()));
    }
  }

  Future<void> _onLoadAddressesFromPrefs(
      LoadAddressesFromPrefs event, Emitter<UserAddressState> emit) async {
    emit(UserAddressLoading());
    try {
      // Load addresses from SharedPreferences
      final addresses = await _addressService.loadAddresses();
      emit(UserAddressLoaded(addresses));
    } catch (e) {
      emit(
          UserAddressError('Failed to load addresses from SharedPreferences.'));
    }
  }
}
