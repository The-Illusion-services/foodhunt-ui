import 'package:food_hunt/services/models/core/address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddressService {
  static const String _addressKey = 'user_addresses';

  // Save a list of addresses to SharedPreferences
  Future<void> saveAddresses(List<UserAddress> addresses) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert addresses to JSON
    final addressesJson = addresses.map((address) => address.toJson()).toList();
    final addressesString = json.encode(addressesJson);

    // Save to SharedPreferences
    await prefs.setString(_addressKey, addressesString);
  }

  // Load addresses from SharedPreferences
  Future<List<UserAddress>> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addressesString = prefs.getString(_addressKey);

    if (addressesString != null) {
      // Decode JSON and convert to List<UserAddress>
      final addressesJson = json.decode(addressesString) as List;
      final addresses =
          addressesJson.map((json) => UserAddress.fromJson(json)).toList();
      return addresses;
    }

    return []; // Return an empty list if no addresses are found
  }

  // Get the primary address
  // Future<UserAddress?> getPrimaryAddress() async {
  //   final addresses = await loadAddresses();

  //   // Find the address with primary: true
  //   return addresses.firstWhere(
  //     (address) => address.primary,
  //     orElse: () => null, // Return null if no primary address is found
  //   );
  // }

  Future<UserAddress?> getPrimaryAddress() async {
    final addresses = await loadAddresses();

    // Find the address with primary: true
    try {
      return addresses.firstWhere(
        (address) => address.primary,
      );
    } catch (e) {
      // Return null if no primary address is found
      return null;
    }
  }

  // Add a new address
  Future<void> addAddress(UserAddress newAddress) async {
    final addresses = await loadAddresses();
    addresses.add(newAddress);
    await saveAddresses(addresses);
  }

  Future<void> addAddresses(List<UserAddress> addresses) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert the list of addresses to JSON
    final addressesJson = addresses.map((address) => address.toJson()).toList();
    final addressesString = json.encode(addressesJson);

    // Save the JSON string to SharedPreferences
    await prefs.setString(_addressKey, addressesString);
  }

  // Set an address as primary
  Future<void> setPrimaryAddress(String addressId) async {
    final addresses = await loadAddresses();

    // Reset primary flag for all addresses
    final updatedAddresses = addresses.map((address) {
      return address.copyWith(primary: address.id == addressId);
    }).toList();

    await saveAddresses(updatedAddresses);
  }
}
