import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Events
abstract class AllRestaurantsEvent extends Equatable {
  const AllRestaurantsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllRestaurants extends AllRestaurantsEvent {}

// States
abstract class AllRestaurantsState extends Equatable {
  const AllRestaurantsState();

  @override
  List<Object?> get props => [];
}

class AllRestaurantsInitial extends AllRestaurantsState {}

class AllRestaurantsLoading extends AllRestaurantsState {}

class AllRestaurantsLoaded extends AllRestaurantsState {
  final List<dynamic> stores;

  const AllRestaurantsLoaded({required this.stores});

  @override
  List<Object> get props => [stores];
}

class AllRestaurantsError extends AllRestaurantsState {
  final String message;

  const AllRestaurantsError({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class AllRestaurantsBloc
    extends Bloc<AllRestaurantsEvent, AllRestaurantsState> {
  final AuthRepository _authRepository;

  AllRestaurantsBloc(this._authRepository) : super(AllRestaurantsInitial()) {
    on<FetchAllRestaurants>(_onFetchAllRestaurants);
  }

  Future<void> _onFetchAllRestaurants(
      FetchAllRestaurants event, Emitter<AllRestaurantsState> emit) async {
    emit(AllRestaurantsLoading());
    try {
      final stores = await _authRepository.fetchAllStores();
      print(stores);
      emit(AllRestaurantsLoaded(stores: stores));
    } catch (e) {
      emit(AllRestaurantsError(message: e.toString()));
    }
  }
}
