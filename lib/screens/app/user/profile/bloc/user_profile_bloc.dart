import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends UserProfileEvent {}

abstract class UserProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final Map<String, dynamic> profileData;

  UserProfileLoaded(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final AuthRepository _authRepository;
  final AuthService authService = AuthService();

  UserProfileBloc(this._authRepository) : super(UserProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final profileData = await _authRepository.getUserProfile();

      print(profileData);

      emit(UserProfileLoaded(profileData));
    } catch (e) {
      emit(UserProfileError('Failed to load store profile.'));
    }
  }
}
