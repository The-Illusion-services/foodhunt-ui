// import 'package:flutter/widgets.dart';
import 'package:food_hunt/core/utils/auth_service_helper.dart';
import 'package:food_hunt/services/api.dart';

class UserRepository {
  final ApiService _apiService;
  final AuthService authService = AuthService();

  UserRepository(this._apiService);

  Future<List<dynamic>> search({
    // Future<Map<String, dynamic>> search({

    required String searchTerm,
  }) async {
    try {
      final response = await _apiService.get('/auth/search/?query=$searchTerm');

      print(response);

      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}
