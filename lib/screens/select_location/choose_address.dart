import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/select_location/confirm_location.dart';
import 'package:food_hunt/services/models/core/address.dart';
// import 'package:food_hunt/screens/select_location/confirm_location.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';

class ChooseAddressScreen extends StatefulWidget {
  const ChooseAddressScreen({Key? key}) : super(key: key);

  @override
  _ChooseAddressScreenState createState() => _ChooseAddressScreenState();
}

class _ChooseAddressScreenState extends State<ChooseAddressScreen> {
  late GoogleMapController mapController;
  final TextEditingController searchController = TextEditingController();
  LatLng? _currentPosition;
  bool _isLoading = false;
  String? _selectedAddress;
  Marker? _selectedMarker;
  Set<Marker> _markers = {};
  late UserAddress _userAddress;
  String googleApiKey = 'Gooogle_key';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x40BEBEBE),
                offset: Offset(0, 4),
                blurRadius: 21.0,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: SvgPicture.string(
                        SvgIcons.arrowLeftIcon,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "Select your address",
                  style: TextStyle(
                    fontFamily: 'JK_Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bodyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Box
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GooglePlaceAutoCompleteTextField(
                  textEditingController: searchController,
                  googleAPIKey: googleApiKey,
                  inputDecoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.grayBackground,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 16),
                    hintText: "Search location",
                    hintStyle: TextStyle(
                      fontFamily: 'JK_Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.placeHolderTextColor,
                      height: 1.4,
                    ),
                    // border: InputBorder.none,
                    // enabledBorder: InputBorder.none,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(8),
                    //   borderSide: BorderSide(
                    //     color: AppColors.grayBorderColor,
                    //   ),
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(8),
                    //   borderSide: BorderSide(
                    //     color: AppColors.placeHolderTextColor,
                    //   ),
                    // ),
                    prefixIcon: IconButton(
                      icon: SvgPicture.string(
                        SvgIcons.locationIcon,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                            Color(0xFF808080), BlendMode.srcIn),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  debounceTime: 800,
                  countries: ["ng"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    _handlePlaceSelection(prediction);
                  },
                  itemClick: (Prediction prediction) {
                    _handlePlaceSelection(prediction);
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 7),
                          Expanded(
                            child: Text(prediction.description ?? ""),
                          )
                        ],
                      ),
                    );
                  },
                  seperatedBuilder: Divider(),
                  isCrossBtnShown: true,
                  // placeType: PlaceType.,
                ),
              ),
              // Use Current Location Button
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 24, top: 12.0),
                child: AppButton(
                  label: "Use current location",
                  onPressed: _useCurrentLocation,
                ),
              ),
              // Map View
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CupertinoActivityIndicator(
                        color: AppColors.primary,
                      ))
                    : GoogleMap(
                        onMapCreated: (controller) {
                          setState(() {
                            mapController = controller;
                          });
                        },
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition ?? LatLng(0, 0),
                          zoom: 14,
                        ),
                        markers: _markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        onTap: (LatLng position) {
                          _getAddressFromLatLng(position);
                        },
                      ),
              ),
            ],
          ),
          if (_selectedAddress != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildAddressConfirmationCard(),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressConfirmationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selected Location",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.bodyTextColor,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _selectedAddress ?? "",
              style: TextStyle(fontSize: 14, color: AppColors.grayTextColor),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmLocationScreen(
                          // address: _selectedAddress as String,
                          // coordinates: _currentPosition as LatLng,
                          userAddress: _userAddress),
                    ),
                  );
                },
                child: Text(
                  "Confirm Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationError('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationError('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationError('Location permissions are permanently denied.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _getAddressFromLatLng(_currentPosition!);
      _handlePlaceSelection(Prediction(
          lat: _currentPosition?.latitude.toString(),
          lng: _currentPosition?.longitude.toString()));
    } catch (e) {
      _showLocationError('Error getting current location: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handlePlaceSelection(Prediction prediction) async {
    if (prediction.lat == null || prediction.lng == null) return;

    final latLng =
        LatLng(double.parse(prediction.lat!), double.parse(prediction.lng!));

    setState(() {
      _currentPosition = latLng;
      _selectedAddress = prediction.description;
      _markers = {
        Marker(
          markerId: MarkerId('selected_location'),
          position: latLng,
          infoWindow: InfoWindow(title: prediction.description),
        ),
      };
    });

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 16),
    );
  }

  // Future<void> _getAddressFromLatLng(LatLng position) async {
  //   try {
  //     final url = Uri.parse(
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey',
  //     );

  //     final response = await http.get(url);
  //     final data = json.decode(response.body);

  //     if (data['status'] == 'OK') {
  //       print(data);
  //       setState(() {
  //         _currentPosition = position;
  //         _selectedAddress = data['results'][0]['formatted_address'];
  //         _markers = {
  //           Marker(
  //             markerId: MarkerId('selected_location'),
  //             position: position,
  //             infoWindow: InfoWindow(title: _selectedAddress),
  //           ),
  //         };
  //       });
  //     }
  //   } catch (e) {
  //     _showLocationError('Error getting address: $e');
  //   }
  // }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final result = data['results'][0];
        final addressComponents = result['address_components'];
        final plusCode = data['plus_code']?['compound_code'] ?? '';

        // Create UserAddress object
        final userAddress = UserAddress(
          address: result['formatted_address'] ?? '',
          street: result['formatted_address'] ?? '',
          houseNumber: "",
          state: "",
          landmark: "",
          plusCode: plusCode,
          primary: false,
          longitude: position.longitude,
          latitude: position.latitude,
        );

        setState(() {
          _currentPosition = position;
          _selectedAddress = result['formatted_address'];
          _markers = {
            Marker(
              markerId: MarkerId('selected_location'),
              position: position,
              infoWindow: InfoWindow(
                title: _selectedAddress,
              ),
            ),
          };

          _userAddress = userAddress;
        });

        // You can now use userAddress object as needed
        print('Parsed UserAddress: ${userAddress.toJson()}');
      }
    } catch (e) {
      _showLocationError('Error getting address: $e');
    }
  }

  void _useCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final latLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = latLng;
      });

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 16),
      );

      await _getAddressFromLatLng(latLng);
    } catch (e) {
      _showLocationError('Error getting current location: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
