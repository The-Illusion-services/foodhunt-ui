import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/routing/routes/app_routes.dart';
import 'package:food_hunt/screens/select_location/confirm_location.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChooseAddressScreen extends StatefulWidget {
  const ChooseAddressScreen({Key? key}) : super(key: key);

  @override
  _ChooseAddressScreenState createState() => _ChooseAddressScreenState();
}

class _ChooseAddressScreenState extends State<ChooseAddressScreen> {
  mapbox.MapboxMap? mapboxMap;
  final MapboxService mapboxService = MapboxService();
  List<dynamic> searchResults = [];
  dynamic selectedAddress;
  bool _isLoading = false;

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
                child: TypeAheadField(
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      cursorColor: AppColors.placeHolderTextColor,
                      decoration: InputDecoration(
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.grayBorderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.grayBorderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.placeHolderTextColor,
                            ),
                          ),
                          prefixIcon: IconButton(
                            icon: SvgPicture.string(
                              SvgIcons.locationIcon,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                  Color(0xFF808080), BlendMode.srcIn),
                            ),
                            onPressed: () {},
                          )),
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: AppColors.bodyTextColor,
                      ),
                    );
                  },
                  suggestionsCallback: (pattern) async {
                    try {
                      return await mapboxService
                          .getAutocompleteSuggestions(pattern);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Error fetching suggestions: $e')),
                      );
                      return [];
                    }
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['formatted']),
                    );
                  },
                  onSelected: (suggestion) {
                    print(suggestion);
                    _handleAddressSelection(suggestion);
                  },
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
                child: mapbox.MapWidget(
                  onMapCreated: _onMapCreated,
                ),
              ),
              // List of Addresses
              if (searchResults.isNotEmpty)
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final address = searchResults[index];
                      return ListTile(
                        title: Text(address['formatted']),
                        onTap: () => _handleAddressSelection(address),
                      );
                    },
                  ),
                ),
            ],
          ),
          // Loading Overlay
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _handleAddressSelection(dynamic suggestion) {
    setState(() {
      selectedAddress = suggestion;
    });

    final coordinates = suggestion['geometry']['coordinates'];
    mapboxMap?.flyTo(
      mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(
            4.3,
            9.0,
          ),
        ),
        zoom: 14,
      ),
      mapbox.MapAnimationOptions(duration: 1000),
    );
    _showAddressConfirmationBottomSheet(suggestion);
  }

  void _onMapCreated(mapbox.MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.loadStyleURI(mapbox.MapboxStyles.MAPBOX_STREETS);
    // mapboxMap.setMapStyle(MapboxStyles.MAPBOX_STREETS);
  }

  void _showAddressConfirmationBottomSheet(dynamic address) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (context) => AddressConfirmationSheet(
        address: address,
        onConfirm: _saveAddress,
      ),
    );
  }

  void _saveAddress(dynamic address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmLocationScreen(
          coordinates: address['center'],
          placeName: address['place_name'],
        ),
      ),
    );
  }

  void _useCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final locationStatus = await _checkLocationPermission();
      if (!locationStatus) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      mapboxMap?.flyTo(
        mapbox.CameraOptions(
          center: mapbox.Point(
            coordinates: mapbox.Position(
              position.longitude,
              position.latitude,
            ),
          ),
          zoom: 14,
        ),
        mapbox.MapAnimationOptions(duration: 1000),
      );

      final address = await mapboxService.reverseGeocode(
        position.longitude,
        position.latitude,
      );

      if (address != null) {
        _showAddressConfirmationBottomSheet(address);
      } else {
        _showLocationError('Unable to fetch address for current location.');
      }
    } catch (e) {
      _showLocationError('Error fetching current location: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationError('Location services are disabled.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationError('Location permissions are denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationError('Location permissions are permanently denied.');
      return false;
    }

    return true;
  }

  void _showLocationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class AddressConfirmationSheet extends StatelessWidget {
  final dynamic address;
  final Function(dynamic) onConfirm;

  const AddressConfirmationSheet({
    Key? key,
    required this.address,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(address);
    return Container(
      // width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            address['place_name'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Coordinates: ${address['center'][0] ?? "..."} , ${address['center'][1] ?? ""}',
            style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: AppColors.subTitleTextColor),
          ),
          const SizedBox(height: 20),
          AppButton(
            onPressed: () {
              onConfirm(address);
            },
            label: 'Select this address',
          ),
        ],
      ),
    );
  }
}

class MapboxService {
  final String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  final String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  Future<List<dynamic>> getAutocompleteSuggestions(String query) async {
    final String url =
        'https://api.geoapify.com/v1/geocode/autocomplete?text=$query&filter=countrycode:ng&format=json&apiKey=31bac372636d457a86f44e3b9f8ccd03';
    // '$baseUrl/$query.json?access_token=$accessToken&country=NG&limit=5';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load autocomplete suggestions');
    }
  }

  Future<dynamic> reverseGeocode(double longitude, double latitude) async {
    final String url =
        '$baseUrl/$longitude,$latitude.json?access_token=$accessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['features'][0]; // Return the first result
    } else {
      return null;
    }
  }
}
