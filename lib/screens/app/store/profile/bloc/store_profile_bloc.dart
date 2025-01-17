import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

abstract class StoreProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchStoreProfile extends StoreProfileEvent {}

abstract class StoreProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoreProfileInitial extends StoreProfileState {}

class StoreProfileLoading extends StoreProfileState {}

class StoreProfileLoaded extends StoreProfileState {
  final Map<String, dynamic> profileData;

  StoreProfileLoaded(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

class StoreProfileError extends StoreProfileState {
  final String message;

  StoreProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class StoreProfileBloc extends Bloc<StoreProfileEvent, StoreProfileState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  StoreProfileBloc(this._restaurantRepository) : super(StoreProfileInitial()) {
    on<FetchStoreProfile>(_onFetchStoreProfile);
  }

  Future<void> _onFetchStoreProfile(
      FetchStoreProfile event, Emitter<StoreProfileState> emit) async {
    emit(StoreProfileLoading());
    try {
      final res = await authService.getRestaurantId();

      final profileData = await _restaurantRepository.getStoreProfile(
        restaurantId: res!, // "1"
      );

      print(profileData);

      emit(StoreProfileLoaded(profileData));
    } catch (e) {
      emit(StoreProfileError('Failed to load store profile.'));
    }
  }
}
