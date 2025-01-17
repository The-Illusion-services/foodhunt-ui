import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class UserStoreEvent extends Equatable {
  const UserStoreEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserStoreProfile extends UserStoreEvent {
  final String storeId;

  const FetchUserStoreProfile(this.storeId);

  @override
  List<Object?> get props => [storeId];
}

// States
abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final Map<String, dynamic> storeProfile;

  const StoreLoaded(this.storeProfile);

  @override
  List<Object> get props => [storeProfile];
}

class StoreError extends StoreState {
  final String message;

  const StoreError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class UserStoreBloc extends Bloc<UserStoreEvent, StoreState> {
  final RestaurantRepository _storeRepository;

  UserStoreBloc(this._storeRepository) : super(StoreInitial()) {
    on<FetchUserStoreProfile>(_onFetchStoreProfile);
  }

  Future<void> _onFetchStoreProfile(
      FetchUserStoreProfile event, Emitter<StoreState> emit) async {
    emit(StoreLoading());
    try {
      print('Fetching store profile');
      final storeProfile =
          await _storeRepository.getStoreProfile(restaurantId: event.storeId);
      print(storeProfile);
      emit(StoreLoaded(storeProfile));
    } catch (e) {
      emit(StoreError('Error fetching store profile: $e'));
    }
  }
}
