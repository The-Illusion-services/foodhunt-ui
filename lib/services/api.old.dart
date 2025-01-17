import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClient extends http.BaseClient {
  final http.Client _inner;
  final FlutterSecureStorage _secureStorage;
  final String baseUrl;

  AuthClient(this.baseUrl, this._secureStorage) : _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final url = request.url.toString();
    final fullUrl = url.startsWith('http')
        ? url
        : baseUrl + (url.startsWith('/') ? url : '/$url');
    final baseRequest = _copyRequest(request, Uri.parse(fullUrl));

    baseRequest.headers['Content-Type'] = 'application/json';

    // Add auth token if available
    final accessToken = await _secureStorage.read(key: 'access_token');
    if (accessToken != null) {
      baseRequest.headers['Authorization'] = 'Bearer $accessToken';
    }

    try {
      // Send the request
      final response = await _inner.send(baseRequest);

      // Handle 401 errors and token refresh
      if (accessToken != null && response.statusCode == 401) {
        final newToken = await _refreshToken();
        await _secureStorage.write(key: 'access_token', value: newToken);

        // Retry the original request with new token
        final retryRequest = _copyRequest(request, Uri.parse(fullUrl));
        retryRequest.headers['Authorization'] = 'Bearer $newToken';
        return await _inner.send(retryRequest);
      }

      return response;
    } catch (e) {
      if (e is ApiException) {
        throw e;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<String> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) {
        await _forceLogout();
        throw ApiException('No refresh token available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        body: jsonEncode({'refresh_token': refreshToken}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        await _forceLogout();
        throw ApiException('Failed to refresh token');
      }

      return jsonDecode(response.body)['access_token'];
    } catch (e) {
      await _forceLogout();
      throw ApiException('Authentication failed: ${e.toString()}');
    }
  }

  http.Request _copyRequest(http.BaseRequest request, Uri newUri) {
    final newRequest = http.Request(request.method, newUri);
    newRequest.headers.addAll(request.headers);

    if (request is http.Request) {
      newRequest.encoding = request.encoding;
      if (request.bodyBytes.isNotEmpty) {
        newRequest.bodyBytes = request.bodyBytes;
      }
    }

    return newRequest;
  }

  Future<void> _forceLogout() async {
    await _secureStorage.deleteAll();
    // Add navigation logic to logout user
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

class ApiService {
  late AuthClient _client;
  final String baseUrl;

  ApiService({required this.baseUrl}) {
    _client = AuthClient(baseUrl, const FlutterSecureStorage());
  }

  // Generic GET method
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(path).replace(queryParameters: queryParams);
      final response = await _client.get(uri);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Generic POST method
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(path).replace(queryParameters: queryParams);

      final response = await _client.post(
        uri,
        body: data != null ? jsonEncode(data) : null,
      );

      return _handleResponse(response);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // PUT method
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(path).replace(queryParameters: queryParams);
      final response = await _client.put(
        uri,
        body: data != null ? jsonEncode(data) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE method
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(path).replace(queryParameters: queryParams);
      final response = await _client.delete(
        uri,
        body: data != null ? jsonEncode(data) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;

      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body;
      }
    }

    return _createHttpError(response);
  }

  ApiException _createHttpError(http.Response response) {
    String message;

    try {
      final body = jsonDecode(response.body);
      message =
          body['message'] ?? body['error'] ?? body['detail'] ?? 'Unknown error';
    } catch (_) {
      switch (response.statusCode) {
        case 400:
          message = 'Bad Request';
          break;
        case 401:
          message = 'Unauthorized';
          break;
        case 403:
          message = 'Forbidden';
          break;
        case 404:
          message = 'Not Found';
          break;
        case 500:
          message = 'Internal Server Error';
          break;
        default:
          message = 'Unexpected error occurred';
      }
    }

    throw ApiException(message);
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
