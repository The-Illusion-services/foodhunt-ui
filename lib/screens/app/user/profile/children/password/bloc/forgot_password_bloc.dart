import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Events
abstract class UserForgotPasswordEvent extends Equatable {
  const UserForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class SendOtp extends UserForgotPasswordEvent {
  const SendOtp();

  @override
  List<Object> get props => [];
}

// States
abstract class UserForgotPasswordState extends Equatable {
  const UserForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends UserForgotPasswordState {}

class ForgotPasswordLoading extends UserForgotPasswordState {}

class ForgotPasswordSuccess extends UserForgotPasswordState {}

class ForgotPasswordFailure extends UserForgotPasswordState {
  final String error;

  const ForgotPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class UserForgotPasswordBloc
    extends Bloc<UserForgotPasswordEvent, UserForgotPasswordState> {
  final AuthRepository _authRepository;
  final AuthService _authService = AuthService();

  UserForgotPasswordBloc(
    this._authRepository,
  ) : super(ForgotPasswordInitial()) {
    on<SendOtp>(_sendOtp);
  }

  Future<void> _sendOtp(
      SendOtp event, Emitter<UserForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      final email = await _authService.getUserEmail();
      await _authRepository.sendOtp(email: email!);
      emit(ForgotPasswordSuccess());
    } catch (error) {
      emit(ForgotPasswordFailure(error.toString()));
    }
  }
}
