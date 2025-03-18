import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

// Events
abstract class StoreDishesEvent extends Equatable {
  const StoreDishesEvent();

  @override
  List<Object?> get props => [];
}

class FetchStoreDishes extends StoreDishesEvent {
  final String storeId;

  const FetchStoreDishes(this.storeId);

  @override
  List<Object?> get props => [storeId];
}

// States
abstract class StoreDishesState extends Equatable {
  const StoreDishesState();

  @override
  List<Object?> get props => [];
}

class StoreDishesInitial extends StoreDishesState {}

class StoreDishesLoading extends StoreDishesState {}

class StoreDishesLoaded extends StoreDishesState {
  final List<dynamic> storeDishes;

  const StoreDishesLoaded(this.storeDishes);

  @override
  List<Object> get props => [storeDishes];
}

class StoreDishesError extends StoreDishesState {
  final String message;

  const StoreDishesError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class StoreDishesBloc extends Bloc<StoreDishesEvent, StoreDishesState> {
  final RestaurantRepository _storeRepository;

  StoreDishesBloc(this._storeRepository) : super(StoreDishesInitial()) {
    on<FetchStoreDishes>(_onFetchStoreDishes);
  }

  Future<void> _onFetchStoreDishes(
      FetchStoreDishes event, Emitter<StoreDishesState> emit) async {
    emit(StoreDishesLoading());
    try {
      print('Fetching store dishes');
      final storeDishes =
          await _storeRepository.fetchAllDishes(restaurantId: event.storeId);
      print(storeDishes);
      emit(StoreDishesLoaded(storeDishes));
    } catch (e) {
      emit(StoreDishesError('Error fetching store profile: $e'));
    }
  }
}
