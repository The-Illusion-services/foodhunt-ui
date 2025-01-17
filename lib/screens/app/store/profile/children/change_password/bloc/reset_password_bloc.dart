import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Events
abstract class StoreResetPasswordEvent extends Equatable {
  const StoreResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SubmitResetDetails extends StoreResetPasswordEvent {
  final String newPassword;
  final String code;

  const SubmitResetDetails({
    required this.newPassword,
    required this.code,
  });

  @override
  List<Object?> get props => [
        newPassword,
        code,
      ];
}

// States
abstract class StoreResetPasswordState extends Equatable {
  const StoreResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends StoreResetPasswordState {}

class ResetPasswordLoading extends StoreResetPasswordState {}

class ResetPasswordSuccess extends StoreResetPasswordState {}

class ResetPasswordFailure extends StoreResetPasswordState {
  final String error;
  const ResetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class StoreResetPasswordBloc
    extends Bloc<StoreResetPasswordEvent, StoreResetPasswordState> {
  final AuthRepository _authRepository;
  final AuthService authService = AuthService();

  StoreResetPasswordBloc(
    this._authRepository,
  ) : super(ResetPasswordInitial()) {
    on<SubmitResetDetails>(_submitResetDetails);
  }

  Future<void> _submitResetDetails(
      SubmitResetDetails event, Emitter<StoreResetPasswordState> emit) async {
    emit(ResetPasswordLoading());

    var email = await authService.getUserEmail();

    try {
      await _authRepository.resetPassword(
        email: email!,
        code: event.code,
        newPassword: event.newPassword,
      );

      emit(ResetPasswordSuccess());
      authService.setHasRestaurantProfile(true);
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}
