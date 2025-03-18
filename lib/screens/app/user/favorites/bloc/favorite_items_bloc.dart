import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

abstract class FavoriteItemsState extends Equatable {
  const FavoriteItemsState();

  @override
  List<Object?> get props => [];
}

class FavoriteItemsLoading extends FavoriteItemsState {}

class FavoriteItemsLoaded extends FavoriteItemsState {
  final List<dynamic> items;

  const FavoriteItemsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class FavoriteItemsEmpty extends FavoriteItemsState {}

class FavoriteItemsError extends FavoriteItemsState {
  final String message;

  const FavoriteItemsError(this.message);

  @override
  List<Object?> get props => [message];
}

abstract class FavoriteItemsEvent extends Equatable {
  const FavoriteItemsEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoriteItems extends FavoriteItemsEvent {}

class FavoriteItemsBloc extends Bloc<FavoriteItemsEvent, FavoriteItemsState> {
  final RestaurantRepository _restaurantRepository;

  FavoriteItemsBloc(this._restaurantRepository)
      : super(FavoriteItemsLoading()) {
    on<LoadFavoriteItems>(_onLoadFavoriteItems);
  }

  Future<void> _onLoadFavoriteItems(
    LoadFavoriteItems event,
    Emitter<FavoriteItemsState> emit,
  ) async {
    emit(FavoriteItemsLoading());
    try {
      final items = await _restaurantRepository.fetchFavoriteItems();

      if (items.isEmpty) {
        emit(FavoriteItemsEmpty());
      } else {
        emit(FavoriteItemsLoaded(items));
      }
    } catch (e) {
      emit(FavoriteItemsError("Failed to load items"));
    }
  }
}
