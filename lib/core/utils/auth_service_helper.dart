import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _accountTypeKey = 'account_type';
  static const String _isVerifiedKey = 'is_verified';
  static const String _hasRestaurantKey = "hasRestaurant";
  static const String _restaurantIdKey = "restaurantId";
  static const String _emailKey = "email";

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Initialize SharedPreferences
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// Save logged-in state
  Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await _prefs;
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  /// Get logged-in state
  Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Save account type
  Future<void> setAccountType(String accountType) async {
    final prefs = await _prefs;
    await prefs.setString(_accountTypeKey, accountType);
  }

  /// Get account type
  Future<String?> getAccountType() async {
    final prefs = await _prefs;
    return prefs.getString(_accountTypeKey);
  }

  /// Save verification status
  Future<void> setVerificationStatus(bool isVerified) async {
    final prefs = await _prefs;
    await prefs.setBool(_isVerifiedKey, isVerified);
  }

  /// Get verification status
  Future<bool> isVerified() async {
    final prefs = await _prefs;
    return prefs.getBool(_isVerifiedKey) ?? false;
  }

  /// Save restaurant profile status
  Future<void> setHasRestaurantProfile(bool hasRestaurant) async {
    final prefs = await _prefs;
    await prefs.setBool(_hasRestaurantKey, hasRestaurant);
  }

  /// Get restaurant profile status
  Future<bool> hasRestaurant() async {
    final prefs = await _prefs;
    return prefs.getBool(_hasRestaurantKey) ?? false;
  }

  /// Save account type
  Future<void> setRestaurantId(String restaurantId) async {
    final prefs = await _prefs;
    await prefs.setString(_restaurantIdKey, restaurantId);
  }

  /// Get account type
  Future<String?> getRestaurantId() async {
    final prefs = await _prefs;
    return prefs.getString(_restaurantIdKey);
  }

  /// Save account type
  Future<void> setUserEmail(String email) async {
    final prefs = await _prefs;
    await prefs.setString(_emailKey, email);
  }

  /// Get account type
  Future<String?> getUserEmail() async {
    final prefs = await _prefs;
    return prefs.getString(_emailKey);
  }

  /// Clear all authentication-related data
  Future<void> clearAuthData() async {
    final prefs = await _prefs;
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_accountTypeKey);
    await prefs.remove(_isVerifiedKey);
  }
}
