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

class ToggleStoreFavorite extends RestaurantsEvent {
  final String storeId;
  final Function onError;

  const ToggleStoreFavorite({
    required this.storeId,
    required this.onError,
  });

  @override
  List<Object?> get props => [storeId];
}

class UpdateStoreFavoriteStatus extends RestaurantsEvent {
  final String storeId;
  final bool isFavorited;

  const UpdateStoreFavoriteStatus({
    required this.storeId,
    required this.isFavorited,
  });

  @override
  List<Object> get props => [storeId, isFavorited];
}

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

  RestaurantsLoaded copyWith({
    Map<String, dynamic>? stores,
  }) {
    return RestaurantsLoaded(
      stores: stores ?? this.stores,
    );
  }
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
    on<ToggleStoreFavorite>(_onToggleStoreFavorite);
    on<UpdateStoreFavoriteStatus>(_onUpdateStoreFavoriteStatus);
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

  Future<void> _onToggleStoreFavorite(
      ToggleStoreFavorite event, Emitter<RestaurantsState> emit) async {
    try {
      await _authRepository.toggleStoreFavorite(event.storeId);
    } catch (e) {
      event.onError();
    }
  }

  void _onUpdateStoreFavoriteStatus(
      UpdateStoreFavoriteStatus event, Emitter<RestaurantsState> emit) {
    if (state is RestaurantsLoaded) {
      final currentState = state as RestaurantsLoaded;
      final updatedStores = Map<String, dynamic>.from(currentState.stores);

      // Update featured restaurants
      if (updatedStores.containsKey('featured_restaurants')) {
        final featuredRestaurants = List<Map<String, dynamic>>.from(
            updatedStores['featured_restaurants'] as List);

        final storeIndex = featuredRestaurants
            .indexWhere((store) => store['id'].toString() == event.storeId);

        if (storeIndex != -1) {
          featuredRestaurants[storeIndex] = {
            ...featuredRestaurants[storeIndex],
            'is_favorited': event.isFavorited,
          };

          updatedStores['featured_restaurants'] = featuredRestaurants;
        }
      }

      // Update all restaurants if they exist in the state
      if (updatedStores.containsKey('all_restaurants')) {
        final allRestaurants = List<Map<String, dynamic>>.from(
            updatedStores['new_restaurants'] as List);

        final storeIndex = allRestaurants
            .indexWhere((store) => store['id'].toString() == event.storeId);

        if (storeIndex != -1) {
          allRestaurants[storeIndex] = {
            ...allRestaurants[storeIndex],
            'is_favorited': event.isFavorited,
          };

          updatedStores['new_restaurants'] = allRestaurants;
        }
      }

      emit(RestaurantsLoaded(stores: updatedStores));
    }
  }
}
