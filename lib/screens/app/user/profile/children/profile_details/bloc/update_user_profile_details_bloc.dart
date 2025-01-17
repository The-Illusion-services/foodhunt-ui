import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Events
abstract class UpdateUserDetailsEvent extends Equatable {
  const UpdateUserDetailsEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserProfile extends UpdateUserDetailsEvent {
  final String firstName;
  final String lastName;

  final String email;
  final String phoneNumber;

  const UpdateUserProfile(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber});

  @override
  List<Object> get props => [firstName, lastName, email, phoneNumber];
}

// States
abstract class UpdateUserDetailsState extends Equatable {
  const UpdateUserDetailsState();

  @override
  List<Object> get props => [];
}

class UserDetailsInitial extends UpdateUserDetailsState {}

class UserDetailsUpdating extends UpdateUserDetailsState {}

class UserDetailsUpdated extends UpdateUserDetailsState {}

class UserDetailsUpdateError extends UpdateUserDetailsState {
  final String message;

  const UserDetailsUpdateError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class UpdateUserDetailsBloc
    extends Bloc<UpdateUserDetailsEvent, UpdateUserDetailsState> {
  final AuthRepository _authRepository;
  final AuthService authService = AuthService();

  UpdateUserDetailsBloc(this._authRepository) : super(UserDetailsInitial()) {
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UpdateUserDetailsState> emit) async {
    emit(UserDetailsUpdating());

    try {
      await _authRepository.updateUserProfile(
        lastName: event.lastName,
        firstName: event.firstName,
        email: event.email,
        phone: event.phoneNumber,
      );

      emit(UserDetailsUpdated());
    } catch (e) {
      emit(UserDetailsUpdateError(e.toString()));
    }
  }
}
