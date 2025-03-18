// verify_code_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

abstract class VerifyCodeEvent extends Equatable {
  const VerifyCodeEvent();

  @override
  List<Object> get props => [];
}

class VerifyCodeRequested extends VerifyCodeEvent {
  final String code;

  const VerifyCodeRequested(this.code);

  @override
  List<Object> get props => [code];
}

abstract class VerifyCodeState extends Equatable {
  const VerifyCodeState();

  @override
  List<Object> get props => [];
}

class VerifyCodeInitial extends VerifyCodeState {}

class VerifyCodeLoading extends VerifyCodeState {}

class VerifyCodeSuccess extends VerifyCodeState {}

class VerifyCodeFailure extends VerifyCodeState {
  final String error;

  const VerifyCodeFailure(this.error);

  @override
  List<Object> get props => [error];
}

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState> {
  final AuthRepository authRepository;
  final AuthService authService = AuthService();

  VerifyCodeBloc(this.authRepository) : super(VerifyCodeInitial()) {
    on<VerifyCodeRequested>(_onVerifyCodeRequested);
  }

  Future<void> _onVerifyCodeRequested(
      VerifyCodeRequested event, Emitter<VerifyCodeState> emit) async {
    emit(VerifyCodeLoading());
    final email = await authService.getUserEmail();
    try {
      await authRepository.verifyCode(
          verificationCode: event.code, email: email!);
      authService.setVerificationStatus(true);
      emit(VerifyCodeSuccess());
    } catch (e) {
      emit(VerifyCodeFailure(e.toString()));
    }
  }
}
