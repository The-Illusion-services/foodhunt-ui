import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Events
abstract class RestaurantsEvent extends Equatable {
  const RestaurantsEvent();

  @override
  List<Object?> get props => [];
}

class FetchRestaurants extends RestaurantsEvent {}

// States
abstract class RestaurantsState extends Equatable {
  const RestaurantsState();

  @override
  List<Object?> get props => [];
}

class RestaurantsInitial extends RestaurantsState {}

class RestaurantsLoading extends RestaurantsState {}

class RestaurantsLoaded extends RestaurantsState {
  final Map<String, dynamic> stores;

  const RestaurantsLoaded({required this.stores});

  @override
  List<Object> get props => [stores];
}

class RestaurantsError extends RestaurantsState {
  final String message;

  const RestaurantsError({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  final AuthRepository _authRepository;

  RestaurantsBloc(this._authRepository) : super(RestaurantsInitial()) {
    on<FetchRestaurants>(_onFetchRestaurants);
  }

  Future<void> _onFetchRestaurants(
      FetchRestaurants event, Emitter<RestaurantsState> emit) async {
    emit(RestaurantsLoading());
    try {
      final stores = await _authRepository.fetchStores();
      emit(RestaurantsLoaded(stores: stores));
    } catch (e) {
      emit(RestaurantsError(message: e.toString()));
    }
  }
}
