import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Custom Exception for API errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

// AuthClient class that handles requests including multipart requests
class AuthClient extends http.BaseClient {
  final http.Client _inner;
  final FlutterSecureStorage _secureStorage;
  final String baseUrl;
  String? _currentToken;

  AuthClient(this.baseUrl, this._secureStorage) : _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final url = request.url.toString();
    final fullUrl = url.startsWith('http')
        ? url
        : baseUrl + (url.startsWith('/') ? url : '/$url');
    final baseRequest = _copyRequest(request, Uri.parse(fullUrl));

    baseRequest.headers['Content-Type'] = 'application/json';

    // Skip adding auth token for specific endpoints
    if (!_shouldSkipAuthHeader(fullUrl)) {
      final accessToken =
          _currentToken ?? await _secureStorage.read(key: 'access_token');
      if (accessToken != null) {
        baseRequest.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    // // Add auth token if available
    // final accessToken = await _secureStorage.read(key: 'access_token');
    // if (accessToken != null) {
    //   baseRequest.headers['Authorization'] = 'Bearer $accessToken';
    // }

    // if (_currentToken != null) {
    //   baseRequest.headers['Authorization'] = 'Bearer $_currentToken';
    // }

    try {
      // Send the request
      final response = await _inner.send(baseRequest);

      // Handle 401 errors and token refresh
      // if (accessToken != null && response.statusCode == 401) {
      //   final newToken = await _refreshToken();
      //   await _secureStorage.write(key: 'access_token', value: newToken);

      //   // Retry the original request with new token
      //   final retryRequest = _copyRequest(request, Uri.parse(fullUrl));
      //   retryRequest.headers['Authorization'] = 'Bearer $newToken';
      //   return await _inner.send(retryRequest);
      // }

      if (response.statusCode == 401 && !_shouldSkipAuthHeader(fullUrl)) {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Update current token and storage
          _currentToken = newToken;
          await _secureStorage.write(key: 'access_token', value: newToken);

          // Retry the original request with new token
          final retryRequest = _copyRequest(request, Uri.parse(fullUrl));
          retryRequest.headers['Authorization'] = 'Bearer $newToken';
          return await _inner.send(retryRequest);
        }
      }

      return response;
    } catch (e) {
      if (e is ApiException) {
        throw e;
      }
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  bool _shouldSkipAuthHeader(String url) {
    final skipAuthEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/verify',
      '/auth/refresh',
    ];

    return skipAuthEndpoints.any((endpoint) => url.contains(endpoint));
  }

  Future<String> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) {
        await _forceLogout();
        throw ApiException('No refresh token available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/refresh/'),
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

  void updateToken(String newToken) {
    _currentToken = newToken;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }

  Future<http.StreamedResponse> multipartPost(
      String path,
      Map<String, String> fields,
      http.MultipartFile file,
      http.MultipartFile? file2) async {
    // final uri = Uri.parse(path);
    // final request = http.MultipartRequest('POST', uri);

    final url = path.toString();
    final fullUrl = path.startsWith('http')
        ? path
        : baseUrl + (path.startsWith('/') ? url : '/$path');
    final request = http.MultipartRequest('POST', Uri.parse(fullUrl));

    // Add fields
    request.fields.addAll(fields);

    // Add files
    request.files.add(file);

    if (file2 != null) {
      request.files.add(file2);
    }

    print(request.files.first);

    // Add authentication headers
    final accessToken = await _secureStorage.read(key: 'access_token');
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    if (_currentToken != null) {
      request.headers['Authorization'] = 'Bearer $_currentToken';
    }

    try {
      return await _inner.send(request);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<http.StreamedResponse> multipartPut(
      String path, Map<String, String> fields, http.MultipartFile file) async {
    final url = path.toString();
    final fullUrl = path.startsWith('http')
        ? path
        : baseUrl + (path.startsWith('/') ? url : '/$path');
    final request = http.MultipartRequest('PUT', Uri.parse(fullUrl));

    // Add fields
    request.fields.addAll(fields);

    // Add files
    request.files.add(file);

    // Add authentication headers
    final accessToken = await _secureStorage.read(key: 'access_token');
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    if (_currentToken != null) {
      request.headers['Authorization'] = 'Bearer $_currentToken';
    }

    print(request.files.first.field);
    print(request.files.first.isFinalized);

    print(request.files.first.contentType);
    print(request.files.first.filename);
    print(request.fields);
    print(request);

    try {
      return await _inner.send(request);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}

// ApiService class that interacts with AuthClient for various HTTP operations
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

      print(response.body);

      return _handleResponse(response);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Generic POST method
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
      print(e);
      rethrow;
    }
  }

  // New multipart POST method
  Future<dynamic> multipartPost(
    String path, {
    required Map<String, String> fields,
    required http.MultipartFile files,
    http.MultipartFile? file2,
  }) async {
    try {
      final response = await _client.multipartPost(path, fields, files, file2);
      print(response);
      print(response.reasonPhrase);

      return _handleResponseStreamed(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> multipartPut(
    String path, {
    required Map<String, String> fields,
    required http.MultipartFile files,
  }) async {
    try {
      final response = await _client.multipartPut(path, fields, files);
      print(response.reasonPhrase);
      return _handleResponseStreamed(response);
    } catch (e) {
      rethrow;
    }
  }

  // Handle streamed response
  dynamic _handleResponseStreamed(http.StreamedResponse response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.contentLength == 0) return null;

      try {
        final body = await response.stream.bytesToString();
        return jsonDecode(body);
      } catch (e) {
        return response.stream.bytesToString();
      }
    }

    return _createHttpError(response as http.Response);
  }

  // Handle regular response
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
      message = body['message'] ??
          body['error'] ??
          body['detail'] ??
          'Something went wrong, please try again.';
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

  void updateToken(String newToken) {
    if (_client is AuthClient) {
      (_client as AuthClient).updateToken(newToken);
    }
  }

  void dispose() {
    _client.close();
  }
}
