import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Event
abstract class FavoriteStoresState extends Equatable {
  const FavoriteStoresState();

  @override
  List<Object?> get props => [];
}

class FavoriteStoresLoading extends FavoriteStoresState {}

class FavoriteStoresLoaded extends FavoriteStoresState {
  final List<dynamic> stores;

  const FavoriteStoresLoaded(this.stores);

  @override
  List<Object?> get props => [stores];
}

class FavoriteStoresEmpty extends FavoriteStoresState {}

class FavoriteStoresError extends FavoriteStoresState {
  final String message;

  const FavoriteStoresError(this.message);

  @override
  List<Object?> get props => [message];
}

// State
abstract class FavoriteStoresEvent extends Equatable {
  const FavoriteStoresEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoriteStores extends FavoriteStoresEvent {}

// Bloc
class FavoriteStoresBloc
    extends Bloc<FavoriteStoresEvent, FavoriteStoresState> {
  final RestaurantRepository _restaurantRepository;

  FavoriteStoresBloc(this._restaurantRepository)
      : super(FavoriteStoresLoading()) {
    on<LoadFavoriteStores>(_onLoadFavoriteStores);
  }

  Future<void> _onLoadFavoriteStores(
    LoadFavoriteStores event,
    Emitter<FavoriteStoresState> emit,
  ) async {
    emit(FavoriteStoresLoading());
    try {
      final stores = await _restaurantRepository.fetchFavoriteStores();

      if (stores.isEmpty) {
        emit(FavoriteStoresEmpty());
      } else {
        emit(FavoriteStoresLoaded(stores));
      }
    } catch (e) {
      emit(FavoriteStoresError("Failed to load stores"));
    }
  }
}
