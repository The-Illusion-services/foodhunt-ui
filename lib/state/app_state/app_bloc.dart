import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';

part 'app_state.dart';

class TabBloc extends Bloc<TabEvents, TabState> {
  TabBloc() : super(InitialTabState()) {
    on<OnInitialTabEvent>(_onInitialTab);
    on<OnDiscoveryTabEvent>(_onDiscoveryTab);
    on<OnCartTabEvent>(_onCartTab);
    on<OnOrdersTabEvent>(_onOrdersTab);
    on<OnProfileTabEvent>(_onProfileTab);
  }

  FutureOr<void> _onInitialTab(
      OnInitialTabEvent event, Emitter<TabState> emit) {
    emit(InitialTabState());
  }

  FutureOr<void> _onDiscoveryTab(
      OnDiscoveryTabEvent event, Emitter<TabState> emit) {
    emit(DiscoveryTabState());
  }

  FutureOr<void> _onCartTab(OnCartTabEvent event, Emitter<TabState> emit) {
    emit(CartTabState());
  }

  FutureOr<void> _onOrdersTab(OnOrdersTabEvent event, Emitter<TabState> emit) {
    emit(OrdersTabState());
  }

  FutureOr<void> _onProfileTab(
      OnProfileTabEvent event, Emitter<TabState> emit) {
    emit(ProfileTabState());
  }
}
