import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

abstract class UserAddressEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserAddress extends UserAddressEvent {}

abstract class UserAddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserAddressInitial extends UserAddressState {}

class UserAddressLoading extends UserAddressState {}

class UserAddressLoaded extends UserAddressState {
  final List<dynamic> addresses;

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
  final AuthService authService = AuthService();

  UserAddressBloc(this._authRepository) : super(UserAddressInitial()) {
    on<FetchUserAddress>(_onFetchUserAddress);
  }

  Future<void> _onFetchUserAddress(
      FetchUserAddress event, Emitter<UserAddressState> emit) async {
    emit(UserAddressLoading());
    try {
      final addresses = await _authRepository.getUserAddresses();

      emit(UserAddressLoaded(addresses));
    } catch (e) {
      emit(UserAddressError('Failed to load store overview.'));
    }
  }
}
