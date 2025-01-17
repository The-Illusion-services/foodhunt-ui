// Main address selection screen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_hunt/screens/select_location/bloc/choose_address_bloc.old.dart';
import 'package:geolocator/geolocator.dart';

class AddressSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressBloc(
        geolocator: Geolocator(),
        // places: GoogleMapsPlaces(apiKey: 'your_api_key'),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Address'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: AddressSelectionBody(),
      ),
    );
  }
}

class AddressSelectionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for address...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: (query) {
                context.read<AddressBloc>().add(SearchAddress(query));
              },
            ),
          ),
          SizedBox(height: 16),

          // Current location button
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              if (state is CurrentAddressLoaded) {
                return ListTile(
                  leading: Icon(Icons.my_location),
                  title: Text('Use current location'),
                  subtitle: Text(state.address.fullAddress),
                  onTap: () => _showConfirmationBottomSheet(
                    context,
                    state.address,
                  ),
                );
              }
              return TextButton.icon(
                icon: Icon(Icons.my_location),
                label: Text('Use current location'),
                onPressed: () {
                  context.read<AddressBloc>().add(GetCurrentAddress());
                },
              );
            },
          ),

          // Search results
          Expanded(
            child: BlocBuilder<AddressBloc, AddressState>(
              builder: (context, state) {
                if (state is AddressSearchResults) {
                  return ListView.builder(
                    itemCount: state.addresses.length,
                    itemBuilder: (context, index) {
                      final address = state.addresses[index];
                      return ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(address.fullAddress),
                        onTap: () => _showConfirmationBottomSheet(
                          context,
                          address,
                        ),
                      );
                    },
                  );
                }
                if (state is AddressLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is AddressError) {
                  return Center(
                    child: Text(state.message,
                        style: TextStyle(color: Colors.red)),
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context, Address address) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Address',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Icon(Icons.location_on,
                size: 48, color: Theme.of(context).primaryColor),
            SizedBox(height: 16),
            Text(
              address.fullAddress,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SaveAddressScreen(address: address),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Save address screen
class SaveAddressScreen extends StatelessWidget {
  final Address address;

  const SaveAddressScreen({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labelController = TextEditingController(text: address.label);

    return Scaffold(
      appBar: AppBar(
        title: Text('Save Address'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16),
                    Text(
                      address.fullAddress,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: labelController,
              decoration: InputDecoration(
                labelText: 'Address Label',
                hintText: 'e.g. Home, Work, etc.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
            ),
            Spacer(),
            ElevatedButton(
              child: Text('Save Address'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
              ),
              onPressed: () {
                // Save address logic here
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
