import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:food_hunt/core/assets/svg.dart';
import 'package:food_hunt/core/config/enums.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/screens/app/user/home/bloc/address_bloc.dart';
import 'package:food_hunt/screens/app/user/profile/children/add_address/bloc/add_address_bloc.dart';
import 'package:food_hunt/widgets/buttons/app_button.dart';
import 'package:food_hunt/widgets/buttons/app_input.dart';
import 'package:food_hunt/widgets/toast/app_toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:flutter/services.dart';

// Stateful Widget
class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  mapbox.MapboxMap? mapboxMap;
  final MapboxService mapboxService = MapboxService();

  final _addressController = TextEditingController();
  final _labelController = TextEditingController();
  bool _isPrimary = false;
  bool _showAddressForm = false;
  dynamic _selectedAddress;
  String _selectedLabel = 'Home';
  bool _showOtherLabelInput = false;

  List<dynamic> searchResults = [];
  bool _isLoading = false;

  dynamic get selectedAddress => _selectedAddress;

  set selectedAddress(dynamic newAddress) {
    setState(() {
      _selectedAddress = newAddress;
      if (newAddress != null) {
        _addressController.text = newAddress['formatted'] ?? '';
      }
    });
  }

  final List<Map<String, dynamic>> _labelOptions = [
    {'label': 'Home', 'icon': Icons.home},
    {'label': 'Work', 'icon': Icons.work},
    {'label': 'School', 'icon': Icons.school},
    {'label': 'Other', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    if (_selectedAddress != null) {
      _addressController.text = _selectedAddress['formatted'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _addressBloc = context.read<AddAddressBloc>();

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
                  _showAddressForm ? "Add Address" : "Select your address",
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
      body: _showAddressForm
          ? _buildAddressForm(_addressBloc)
          : _buildSearchView(),
    );
  }

  Widget _buildSearchView() {
    return Stack(children: [
      Column(
        children: [
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
                      ),
                    ),
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
                    return await MapboxService()
                        .getAutocompleteSuggestions(pattern);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error fetching suggestions: $e')),
                    );
                    return [];
                  }
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion?['formatted'],
                        style: TextStyle(
                            fontFamily: Font.jkSans.fontName,
                            color: AppColors.subTitleTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  );
                },
                loadingBuilder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Center(
                        child: Theme.of(context).platform == TargetPlatform.iOS
                            ? const CupertinoActivityIndicator(
                                radius: 12,
                                color: AppColors.primary,
                              )
                            : const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                )))),
                emptyBuilder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Text(
                      'No items found!',
                      style: TextStyle(
                        fontFamily: 'JK_Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: AppColors.bodyTextColor,
                      ),
                    )),
                onSelected: (suggestion) {
                  _showOnMap(suggestion);
                  _showAddressConfirmationBottomSheet(suggestion);
                },
                hideOnError: true,
              )),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 24, top: 12.0),
            child: AppButton(
              label: "Use current location",
              onPressed: _useCurrentLocation,
            ),
          ),
          Expanded(
            child: mapbox.MapWidget(
              onMapCreated: _onMapCreated,
            ),
          ),
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
          // Loading Overlay
          if (_isLoading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    ]);
  }

  Widget _buildAddressForm(AddAddressBloc _addressBloc) {
    // final _addressBloc = context.read<AddAddressBloc>();

    return SingleChildScrollView(
        child: BlocConsumer<AddAddressBloc, AddAddressState>(
      listener: (context, state) {
        if (state is AddressAdded) {
          ToastWidget.showToast(
            context: context,
            type: ToastificationType.success,
            title: 'Success',
            description: 'Address saved!',
            icon: SvgPicture.string(
              SvgIcons.successIcon,
              width: 20,
              height: 20,
              semanticsLabel: "Success",
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          );
          Navigator.pop(context);
          context.read<UserAddressBloc>().add(FetchUserAddress());
        }

        if (state is AddressError) {
          ToastWidget.showToast(
            context: context,
            type: ToastificationType.error,
            title: 'Error',
            description: '${state.message}',
            icon: SvgPicture.string(
              SvgIcons.errorIcon,
              width: 20,
              height: 20,
              semanticsLabel: "Success",
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextArea(
                label: "Address",
                hintText: 'Enter address',
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                "Give your address a label",
                style: TextStyle(
                  fontFamily: 'JK_Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelTextColor,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _labelOptions.map((option) {
                  return OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedLabel = option['label'];
                        _showOtherLabelInput = option['label'] == 'Other';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _selectedLabel == option['label']
                            ? AppColors.primary
                            : AppColors.grayTextColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    icon: Icon(
                      option['icon'],
                      size: 16,
                      color: _selectedLabel == option['label']
                          ? AppColors.primary
                          : AppColors.grayTextColor,
                    ),
                    label: Text(
                      option['label'],
                      style: TextStyle(
                        color: _selectedLabel == option['label']
                            ? AppColors.primary
                            : AppColors.grayTextColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              if (_showOtherLabelInput)
                AppInputField(
                  label: "Custom Label",
                  hintText: 'Enter custom label',
                  controller: _labelController,
                  maxLength: 30,
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: AppColors.primary,
                    value: _isPrimary,
                    onChanged: (value) {
                      setState(() {
                        _isPrimary = value!;
                      });
                    },
                  ),
                  Text('Set as primary address',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: Font.jkSans.fontName,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grayTextColor)),
                ],
              ),
              SizedBox(height: 32),
              AppButton(
                label: "Save address",
                isLoading: state is AddressLoading,
                isDisabled: state is AddressLoading,
                onPressed: () {
                  final label = _selectedLabel == 'Other'
                      ? _labelController.text
                      : _selectedLabel;

                  if (selectedAddress == null) {
                    print("Selected address is null");
                    return;
                  }

                  if (selectedAddress['lon'] == null ||
                      selectedAddress['lat'] == null) {
                    print("Invalid coordinates in selected address");
                    return;
                  }

                  // _addressBloc.add(
                  //   AddAddress(
                  //     address: _addressController.text,
                  //     isPrimary: _isPrimary,
                  //     longitude: selectedAddress['lon'],
                  //     latitude: selectedAddress['lat'],
                  //     plusCode: selectedAddress['plus_code'],
                  //     label: label,
                  //   ),
                  // );
                },
              ),
            ],
          ),
        );
      },
    ));
  }

  void _onMapCreated(mapbox.MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.loadStyleURI(mapbox.MapboxStyles.MAPBOX_STREETS);
    // mapboxMap.setMapStyle(MapboxStyles.MAPBOX_STREETS);
  }

  void _showOnMap(dynamic address) async {
    final pointAnnotationManager =
        await mapboxMap?.annotations.createPointAnnotationManager();

    Uint8List bytes = await loadImageFromAsset(AppAssets.marker);

    final pointAnnotationOptions = mapbox.PointAnnotationOptions(
      geometry: mapbox.Point(
        coordinates: mapbox.Position(
          address['lon'],
          address['lat'],
        ),
      ),
      image: bytes, // Your marker image
    );

    // Add annotation to map
    await pointAnnotationManager?.create(pointAnnotationOptions);

    mapboxMap?.flyTo(
      mapbox.CameraOptions(
        center: mapbox.Point(
          coordinates: mapbox.Position(
            address['lon'],
            address['lat'],
          ),
        ),
        zoom: 14,
      ),
      mapbox.MapAnimationOptions(duration: 1000),
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

  void _useCurrentLocation() async {
    setState(() {});

    try {
      final locationStatus = await _checkLocationPermission();
      if (!locationStatus) {
        setState(() {});
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Create annotation
      final pointAnnotationManager =
          await mapboxMap?.annotations.createPointAnnotationManager();

      Uint8List bytes = await loadImageFromAsset(AppAssets.marker);

      final pointAnnotationOptions = mapbox.PointAnnotationOptions(
        geometry: mapbox.Point(
          coordinates: mapbox.Position(
            position.longitude,
            position.latitude,
          ),
        ),
        image: bytes, // Your marker image
      );

      // Add annotation to map
      await pointAnnotationManager?.create(pointAnnotationOptions);

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
        // _showLocationError('Unable to fetch address for current location.');
      }
    } catch (e) {
      print(e);
      // _showLocationError('Error fetching current location: $e');
    } finally {
      setState(() {});
    }
  }

  Future<Uint8List> loadImageFromAsset(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
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

  void _showAddressConfirmationBottomSheet(dynamic address) {
    print(address);
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
    setState(() {
      selectedAddress = address;
      _showAddressForm = true;
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _labelController.dispose();
    super.dispose();
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
            address?['formatted'] ?? "",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Coordinates: ${address['lon'] ?? "..."} , ${address['lat'] ?? ""}',
            style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: AppColors.subTitleTextColor),
          ),
          const SizedBox(height: 10),
          Text(
            '${address['plus_code'] ?? "..."}',
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
    print(query);
    final String url =
        'https://api.geoapify.com/v1/geocode/autocomplete?text=$query&filter=countrycode:ng&format=json&apiKey=31bac372636d457a86f44e3b9f8ccd03';

    final response = await http.get(Uri.parse(url));

    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load autocomplete suggestions');
    }
  }

  Future<dynamic> reverseGeocode(double lon, double lat) async {
    final String url =
        // '$baseUrl/$longitude,$latitude.json?access_token=$accessToken';
        'https://api.geoapify.com/v1/geocode/reverse?lat=$lat&lon=$lon&format=json&apiKey=31bac372636d457a86f44e3b9f8ccd03';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'][0];
    } else {
      return null;
    }
  }
}
