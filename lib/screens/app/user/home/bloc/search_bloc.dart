import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/repositories/user_repository.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchItem extends SearchEvent {
  final String searchTerm;

  SearchItem(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class Searching extends SearchState {}

class SearchComplete extends SearchState {
  // final Map<String, dynamic> items;
  final List<dynamic> items;

  SearchComplete(this.items);

  @override
  List<Object?> get props => [items];
}

class SearchFailure extends SearchState {
  final String message;

  SearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserRepository _userRepository;
  final AuthService authService = AuthService();

  SearchBloc(this._userRepository) : super(SearchInitial()) {
    on<SearchItem>(_onSearchItem);
  }

  Future<void> _onSearchItem(
      SearchItem event, Emitter<SearchState> emit) async {
    emit(Searching());
    try {
      final items = await _userRepository.search(searchTerm: event.searchTerm);

      emit(SearchComplete(items));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }
}
