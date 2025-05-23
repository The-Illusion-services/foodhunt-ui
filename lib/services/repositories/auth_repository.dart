// Repository
import 'dart:io';

// import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_hunt/services/models/core/address.dart';
import 'package:http/http.dart' as http;
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiService _apiService;
  final FlutterSecureStorage _storage;

  final AuthService authService = AuthService();

  AuthRepository(this._apiService, this._storage);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Got here');
      final response = await _apiService.post('/auth/login/', data: {
        'email': email,
        'password': password,
      });

      print(response);

      await _storage.write(
          key: 'access_token', value: response['access_token']);
      await _storage.write(
          key: 'refresh_token', value: response['refresh_token']);
      await _storage.write(key: 'account_type', value: response['role']);
      await _storage.write(key: 'account_type', value: response.toString());

      // Set Auth properties to state
      await authService.setLoggedIn(true);

      await authService.setUserEmail(response['email']);

      await authService.setAccountType(response['role']);

      await authService.setVerificationStatus(response['is_verified']);

      await authService.setHasRestaurantProfile(response['has_restaurant']);

      _apiService.updateToken(response['access_token']);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> createAccount(
      {required String first_name,
      required String middle_name,
      required String last_name,
      required String email,
      required String role,
      required String password,
      required String confirm_password}) async {
    try {
      print('Got here');
      final response = await _apiService.post('/auth/register/', data: {
        "first_name": first_name,
        "middle_name": last_name,
        "last_name": last_name,
        "email": email,
        "role": role,
        "password": password,
        "confirm_password": confirm_password
      });

      print(response);

      await _storage.write(
          key: 'access_token', value: response['access_token']);

      await _storage.write(
          key: 'refresh_token', value: response['refresh_token']);
      await _storage.write(key: 'account_type', value: response['role']);
      // await _storage.write(key: 'account_type', value: response.toString());

      // Set Auth properties to state
      await authService.setLoggedIn(true);

      await authService.setUserEmail(email);

      await authService.setAccountType(response['role']);

      await authService.setVerificationStatus(response['is_verified']);

      await authService.setHasRestaurantProfile(false);

      _apiService.updateToken(response['access_token']);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await _storage.deleteAll();
    await authService.clearAuthData();
    await preferences.clear();
  }

  Future<Map<String, dynamic>> createStore({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String description,
    required String storeType,
    required File? profileImage,
    required File? headerImage,
  }) async {
    try {
      final fields = {
        'name': name.toString(),
        'bio': description.toString(),
        'category': storeType.toString(),
        'phone': phone.toString(),
        'email': email.toString(),
        'address': address.toString(),
      };

      final file1 = await http.MultipartFile.fromPath(
        'profile_image',
        profileImage!.path,
      );

      final file2 = await http.MultipartFile.fromPath(
        'header_image',
        headerImage!.path,
      );

      final response = await _apiService.multipartPost(
          '/restaurant/create-rest/',
          fields: fields,
          files: file1,
          file2: file2);

      print(response);

      return response;
    } catch (e) {
      throw AuthenticationException(e.toString());
    }
  }

  Future<Map<String, dynamic>> updateStoreProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String description,
    required String storeType,
    required File? profileImage,
    required File? headerImage,
  }) async {
    try {
      final fields = {
        'name': name.toString(),
        'bio': description.toString(),
        'category': storeType.toString(),
        'phone': phone.toString(),
        'email': email.toString(),
        'address': address.toString(),
      };

      print(profileImage);

      final file1 = await http.MultipartFile.fromPath(
        'profile_image',
        profileImage!.path,
      );

      // final file2 = await http.MultipartFile.fromPath(
      //   'header_image',
      //   headerImage!.path,
      // );

      final response = await _apiService.multipartPut(
        '/restaurant/update-profile/',
        fields: fields,
        files: file1,
      );

      print(response);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> resendVerificationCode({
    required String email,
  }) async {
    try {
      final response = await _apiService.post('/auth/resend-code/', data: {
        "email": email,
      });

      print(response);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> verifyCode({
    required String email,
    required String verificationCode,
  }) async {
    try {
      final response = await _apiService.post('/auth/verify/',
          data: {"email": email, 'verification_code': verificationCode});

      print(response);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> verifyKYC({
    required String nin,
    required String? ninImage,
  }) async {
    try {
      final response =
          await _apiService.post('/restaurant/create-rest/', data: {
        "nin": nin,
        "ninImage": ninImage,
      });

      print(response);

      return response;
    } catch (e) {
      throw AuthenticationException(e.toString());
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String code,
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post('/auth/reset-password/',
          data: {"email": email, "code": code, "new_password": newPassword});

      print(response);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> sendOtp({
    required String email,
  }) async {
    try {
      final response = await _apiService.post('/auth/forgot-password/', data: {
        "email": email,
      });

      print(response);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // User
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _apiService.get(
        '/auth/user/',
      );

      print(response);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> updateUserProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await _apiService.put(
        '/auth/user/',
      );

      print(response);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // Address

  Future<List<UserAddress>> getUserAddresses() async {
    try {
      final response = await _apiService.get('/auth/address/');

      if (response['data'] != null && response['data'] is List) {
        return (response['data'] as List)
            .map((json) => UserAddress.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to fetch user addresses: $e');
    }
  }

  Future<Map<String, dynamic>> saveAddress(
      {required String houseNumber,
      required String street,
      required String landmark,
      required String state,
      String? label,
      required bool isPrimary,
      String? plusCode,
      dynamic longitude,
      dynamic latitude}) async {
    try {
      final response = await _apiService.post('/auth/address/', data: {
        "house_number": houseNumber,
        "state": state,
        "street": street,
        "landmark": landmark,
        "primary": isPrimary,
        "label": label,
        'longitude': longitude,
        "latitude": latitude
      });

      print(response['data']['details']);

      return response['data']['details'];
    } catch (e) {
      throw e.toString();
    }
  }

  // Stores
  Future<Map<String, dynamic>> fetchStores() async {
    try {
      final response = await _apiService.get(
        '/auth/restaurants/',
      );

      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<dynamic>> fetchAllStores() async {
    try {
      final response = await _apiService.get(
        '/restaurant/all-restaurants/',
      );

      return response['restaurants'];
    } catch (e) {
      throw e.toString();
    }
  }

  // Update favorite stores
  Future<void> toggleStoreFavorite(String storeId) async {
    try {
      final response = await _apiService.post(
        '/restaurant//${storeId}/favorite/',
      );

      print(response);

      // if (response.status != 200 || response.status != 201) {
      //   throw Exception('Failed to update favorite status');
      // }
    } catch (e) {
      throw Exception('Failed to update favorite status: ${e.toString()}');
    }
  }
}

// Exceptions
class AuthenticationException implements Exception {
  final String message;
  AuthenticationException(this.message);
}
