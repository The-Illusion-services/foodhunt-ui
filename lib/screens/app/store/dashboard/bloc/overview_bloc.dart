import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/restaurant_repository.dart';

abstract class StoreOverviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchStoreOverview extends StoreOverviewEvent {}

abstract class StoreOverviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoreOverviewInitial extends StoreOverviewState {}

class StoreOverviewLoading extends StoreOverviewState {}

class StoreOverviewLoaded extends StoreOverviewState {
  final Map<String, dynamic> overviewData;

  StoreOverviewLoaded(this.overviewData);

  @override
  List<Object?> get props => [overviewData];
}

class StoreOverviewError extends StoreOverviewState {
  final String message;

  StoreOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}

class StoreOverviewBloc extends Bloc<StoreOverviewEvent, StoreOverviewState> {
  final RestaurantRepository _restaurantRepository;
  final AuthService authService = AuthService();

  StoreOverviewBloc(this._restaurantRepository)
      : super(StoreOverviewInitial()) {
    on<FetchStoreOverview>(_onFetchStoreOverview);
  }

  Future<void> _onFetchStoreOverview(
      FetchStoreOverview event, Emitter<StoreOverviewState> emit) async {
    emit(StoreOverviewLoading());
    try {
      final overviewData = await _restaurantRepository.getStoreOverview();

      authService.setRestaurantId(overviewData['id'].toString());

      print(overviewData['id'].toString());
      print(overviewData);

      emit(StoreOverviewLoaded(overviewData));
    } catch (e) {
      emit(StoreOverviewError('Failed to load store overview.'));
    }
  }
}
