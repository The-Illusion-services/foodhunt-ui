import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

abstract class CreateAccountEvent {}

class CreateAccountRequested extends CreateAccountEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String accountType;
  final String confirmPassword;
  final String password;

  CreateAccountRequested({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.accountType,
    required this.confirmPassword,
    required this.password,
  });
}

// States
abstract class CreateAccountState {}

class CreateAccountInitial extends CreateAccountState {}

class CreateAccountLoading extends CreateAccountState {}

class AccountCreated extends CreateAccountState {
  AccountCreated();
}

class CreateAccountError extends CreateAccountState {
  final String errorMessage;

  CreateAccountError(this.errorMessage);
}

// Bloc
class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  final AuthRepository _authRepository;

  CreateAccountBloc(this._authRepository) : super(CreateAccountInitial()) {
    on<CreateAccountRequested>(_onCreateAccount);
  }

  Future<void> _onCreateAccount(
      CreateAccountRequested event, Emitter<CreateAccountState> emit) async {
    emit(CreateAccountLoading());
    try {
      final response = await _authRepository.createAccount(
        email: event.email,
        password: event.password,
        first_name: event.firstName,
        middle_name: "",
        last_name: event.lastName,
        role: event.accountType,
        confirm_password: event.confirmPassword,
      );

      emit(AccountCreated());

      print("response");
      print(response);
    } catch (error) {
      String errorMessage;

      // Handle specific exceptions
      if (error is AuthenticationException) {
        errorMessage = error.message;
      } else if (error is DioException) {
        errorMessage = error.response?.data['message'] ?? error.message;
      } else {
        errorMessage = error.toString();
      }

      print("Error: $errorMessage");

      emit(CreateAccountError(errorMessage));
    }
  }
}
