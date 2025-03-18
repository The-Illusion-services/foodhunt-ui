import 'package:flutter/material.dart';
import 'package:osm_search_and_pick/open_street_map_search_and_pick.dart';

class ChooseAddressScreen extends StatelessWidget {
  const ChooseAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a Location'),
        backgroundColor: Colors.blue,
      ),
      body: OpenStreetMapSearchAndPick(
        buttonTextStyle:
            const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
        buttonColor: Colors.blue,
        buttonText: 'Set Current Location',
        onPicked: (pickedData) {
          print('Latitude: ${pickedData.latLong.latitude}');
          print('Longitude: ${pickedData.latLong.longitude}');
          print('Address: ${pickedData.address}');
          print('Address Name: ${pickedData.addressName}');

          // Optionally, navigate back with selected location
          Navigator.pop(context, pickedData);
        },
        inputDecoration: null,
      ),
    );
  }
}
