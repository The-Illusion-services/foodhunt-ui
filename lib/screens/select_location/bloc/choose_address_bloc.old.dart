import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class Address {
  final String id;
  final String fullAddress;
  final double latitude;
  final double longitude;
  final String label;

  Address({
    required this.id,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    required this.label,
  });
}

// Address state
abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class CurrentAddressLoaded extends AddressState {
  final Address address;
  CurrentAddressLoaded(this.address);
}

class AddressSearchResults extends AddressState {
  final List<Address> addresses;
  AddressSearchResults(this.addresses);
}

class AddressError extends AddressState {
  final String message;
  AddressError(this.message);
}

// Address events
abstract class AddressEvent {}

class GetCurrentAddress extends AddressEvent {}

class SearchAddress extends AddressEvent {
  final String query;
  SearchAddress(this.query);
}

class SelectAddress extends AddressEvent {
  final Address address;
  SelectAddress(this.address);
}

// Address BLoC
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final Geolocator geolocator;
  // final GoogleMapsPlaces places;

  AddressBloc({
    required this.geolocator,
  }) : super(AddressInitial()) {
    on<GetCurrentAddress>(_getCurrentAddress);
    // on<SearchAddress>(_searchAddress);
    on<SelectAddress>(_selectAddress);
  }

  Future<void> _getCurrentAddress(
      GetCurrentAddress event, Emitter<AddressState> emit) async {
    try {
      emit(AddressLoading());

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final placemarks = null;
      // await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final address = Address(
            id: DateTime.now().toString(),
            fullAddress:
                '${placemark.street}, ${placemark.locality}, ${placemark.country}',
            latitude: position.latitude,
            longitude: position.longitude,
            label: 'Current Location');

        emit(CurrentAddressLoaded(address));
      }
    } catch (e) {
      emit(AddressError('Failed to get current location: $e'));
    }
  }

  // Future<void> _searchAddress(
  //     SearchAddress event, Emitter<AddressState> emit) async {
  //   try {
  //     emit(AddressLoading());

  //     // final result = await places.autocomplete(event.query,
  //     //     components: [Component(Component.country, 'your_country_code')]);

  //     final addresses = result.predictions
  //         .map((prediction) => Address(
  //             id: prediction.placeId ?? '',
  //             fullAddress: prediction.description ?? '',
  //             latitude: 0, // You'll need to get these from place details
  //             longitude: 0,
  //             label: 'Searched Location'))
  //         .toList();

  //     emit(AddressSearchResults(addresses));
  //   } catch (e) {
  //     emit(AddressError('Failed to search addresses: $e'));
  //   }
  // }

  Future<void> _selectAddress(
      SelectAddress event, Emitter<AddressState> emit) async {
    // Handle address selection
  }
}
