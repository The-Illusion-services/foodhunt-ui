import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:food_hunt/services/repositories/auth_repository.dart';

// Events
abstract class VerifyKYCEvent extends Equatable {
  const VerifyKYCEvent();

  @override
  List<Object?> get props => [];
}

class SubmitKYCDetails extends VerifyKYCEvent {
  final String nin;
  final String ninImage;

  const SubmitKYCDetails({
    required this.nin,
    required this.ninImage,
  });

  @override
  List<Object?> get props => [
        nin,
        ninImage,
      ];
}

// States
abstract class VerifyKYCState extends Equatable {
  const VerifyKYCState();

  @override
  List<Object?> get props => [];
}

class VerifyKYCInitial extends VerifyKYCState {}

class VerifyKYCLoading extends VerifyKYCState {}

class VerifyKYCSuccess extends VerifyKYCState {}

class VerifyKYCFailure extends VerifyKYCState {
  final String error;
  const VerifyKYCFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class VerifyKYCBloc extends Bloc<VerifyKYCEvent, VerifyKYCState> {
  final AuthRepository _authRepository;

  VerifyKYCBloc(
    this._authRepository,
  ) : super(VerifyKYCInitial()) {
    on<SubmitKYCDetails>(_submitStoreDetails);
  }

  Future<void> _submitStoreDetails(
      SubmitKYCDetails event, Emitter<VerifyKYCState> emit) async {
    emit(VerifyKYCLoading());
    try {
      await _authRepository.verifyKYC(
        nin: event.nin,
        ninImage: event.ninImage,
      );

      emit(VerifyKYCSuccess());
    } catch (e) {
      emit(VerifyKYCFailure(e.toString()));
    }
  }
}
