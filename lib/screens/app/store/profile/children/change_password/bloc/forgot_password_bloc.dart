import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Events
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class SendOtp extends ForgotPasswordEvent {
  const SendOtp();

  @override
  List<Object> get props => [];
}

// States
abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;

  const ForgotPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}

// BLoC
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _authRepository;
  final AuthService _authService = AuthService();

  ForgotPasswordBloc(
    this._authRepository,
  ) : super(ForgotPasswordInitial()) {
    on<SendOtp>(_sendOtp);
  }

  Future<void> _sendOtp(
      SendOtp event, Emitter<ForgotPasswordState> emit) async {
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
