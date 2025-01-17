import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Events
abstract class UserResetPasswordEvent extends Equatable {
  const UserResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SubmitResetDetails extends UserResetPasswordEvent {
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
abstract class UserResetPasswordState extends Equatable {
  const UserResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends UserResetPasswordState {}

class ResetPasswordLoading extends UserResetPasswordState {}

class ResetPasswordSuccess extends UserResetPasswordState {}

class ResetPasswordFailure extends UserResetPasswordState {
  final String error;
  const ResetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class UserResetPasswordBloc
    extends Bloc<UserResetPasswordEvent, UserResetPasswordState> {
  final AuthRepository _authRepository;
  final AuthService authService = AuthService();

  UserResetPasswordBloc(
    this._authRepository,
  ) : super(ResetPasswordInitial()) {
    on<SubmitResetDetails>(_submitResetDetails);
  }

  Future<void> _submitResetDetails(
      SubmitResetDetails event, Emitter<UserResetPasswordState> emit) async {
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
