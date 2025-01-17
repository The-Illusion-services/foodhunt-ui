import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;

  LoginRequested({
    required this.email,
    required this.password,
  });
}

class LogoutRequested extends LoginEvent {}

// States
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoggedIn extends LoginState {
  final String userId;
  final String accountType;
  final bool hasRestaurantProfile;

  LoggedIn(
      {required this.userId,
      required this.accountType,
      required this.hasRestaurantProfile});
}

class LoginError extends LoginState {
  final String errorMessage;

  LoginError(this.errorMessage);
}

// Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      print("response");
      print(response);

      emit(LoggedIn(
        userId: '111',
        hasRestaurantProfile: response['has_restaurant'],
        accountType: response['role'],
      ));
    } catch (error) {
      String errorMessage;

      // Handle specific exceptions
      if (error is AuthenticationException) {
        errorMessage = error.message; // Use the custom message
      } else if (error is DioException) {
        // If using Dio, get detailed info from DioException
        errorMessage = error.response?.data['message'] ??
            error.message; // Check if server returned an error message
      } else {
        // Fallback for any unknown error
        errorMessage = error.toString();
      }

      print("Error: $errorMessage");

      emit(LoginError(errorMessage));
    }
  }

  Future<void> _onLogout(
      LogoutRequested event, Emitter<LoginState> emit) async {
    await _authRepository.logout();
    emit(LoginInitial());
  }
}
