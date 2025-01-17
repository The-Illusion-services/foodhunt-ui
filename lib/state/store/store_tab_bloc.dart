import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'store_tab_event.dart';

part 'store_tab_state.dart';

class StoreTabBloc extends Bloc<StoreTabEvents, StoreTabState> {
  StoreTabBloc() : super(StoreDashboardState()) {
    // Store
    on<OnStoreDashboardTabEvent>(_storeDashboard);
    on<OnStoreOrdersTabEvent>(_storeOrders);
    on<OnStoreMenuTabEvent>(_storeMenu);
    on<OnStoreProfileTabEvent>(_storeProfile);
  }

  FutureOr<void> _storeDashboard(
      OnStoreDashboardTabEvent event, Emitter<StoreTabState> emit) {
    emit(StoreDashboardState());
  }

  FutureOr<void> _storeOrders(
      OnStoreOrdersTabEvent event, Emitter<StoreTabState> emit) {
    emit(StoreOrdersTabState());
  }

  FutureOr<void> _storeMenu(
      OnStoreMenuTabEvent event, Emitter<StoreTabState> emit) {
    emit(StoreMenuTabState());
  }

  FutureOr<void> _storeProfile(
      OnStoreProfileTabEvent event, Emitter<StoreTabState> emit) {
    emit(StoreProfileTabState());
  }
}
