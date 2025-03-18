import 'package:dio/dio.dart';

class PaystackService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.paystack.co';
  final String _secretKey = 'sk_test_dc3b88f8c5a5a71cfd86e6609f5c8fc2b112d981';

  PaystackService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $_secretKey',
      'Content-Type': 'application/json',
    };
  }

  Future<Map<String, dynamic>?> initializeTransaction({
    required String email,
    required int amount,
    required dynamic reference,
  }) async {
    try {
      final response = await _dio.post('/transaction/initialize', data: {
        'email': email,
        'amount': amount,
        'reference': reference.toString()
      });

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('Error initializing transaction: $e');
    }
    return null;
  }
}
