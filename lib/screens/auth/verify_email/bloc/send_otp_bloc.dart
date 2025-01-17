// send_code_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

abstract class ResendCodeEvent extends Equatable {
  const ResendCodeEvent();

  @override
  List<Object> get props => [];
}

class ResendCodeRequested extends ResendCodeEvent {
  const ResendCodeRequested();

  @override
  List<Object> get props => [];
}

abstract class ResendCodeState extends Equatable {
  const ResendCodeState();

  @override
  List<Object> get props => [];
}

class ResendCodeInitial extends ResendCodeState {}

class ResendCodeLoading extends ResendCodeState {}

class ResendCodeSuccess extends ResendCodeState {}

class ResendCodeFailure extends ResendCodeState {
  final String error;

  const ResendCodeFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ResendVerifyCodeBloc extends Bloc<ResendCodeEvent, ResendCodeState> {
  final AuthRepository authRepository;
  final AuthService authService = AuthService();

  ResendVerifyCodeBloc(this.authRepository) : super(ResendCodeInitial()) {
    on<ResendCodeRequested>(_onResendCodeRequested);
  }

  Future<void> _onResendCodeRequested(
      ResendCodeRequested event, Emitter<ResendCodeState> emit) async {
    emit(ResendCodeLoading());
    final email = await authService.getUserEmail();
    try {
      await authRepository.resendVerificationCode(email: email!);
      emit(ResendCodeSuccess());
    } catch (e) {
      emit(ResendCodeFailure(e.toString()));
    }
  }
}
