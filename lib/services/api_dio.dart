import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Dio dio;

  AuthInterceptor(this.dio, this._secureStorage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _secureStorage.read(key: 'access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await _refreshToken();
        await _secureStorage.write(key: 'access_token', value: newToken);

        // Retry original request with updated token
        final retryResponse = await _retryRequest(err.requestOptions);
        return handler.resolve(retryResponse);
      } catch (e) {
        await _forceLogout();
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  Future<String> _refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');
    final response =
        await dio.post('/refresh', data: {'refresh_token': refreshToken});
    return response.data['access_token'];
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return await dio.request(requestOptions.path,
        options: options,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters);
  }

  Future<void> _forceLogout() async {
    await _secureStorage.deleteAll();
    // Add navigation logic to logout user
  }
}

class ApiService {
  late Dio _dio;
  final String baseUrl;

  ApiService({required this.baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     // Can add token, custom headers here
    //     return handler.next(options);
    //   },
    //   onResponse: (response, handler) {
    //     return handler.next(response);
    //   },
    //   onError: (DioException e, handler) {
    //     return handler.next(e);
    //   },
    // ));

    _dio.interceptors.add(AuthInterceptor(_dio, const FlutterSecureStorage()));
  }

  // Generic GET method
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // Generic POST method
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    print("Calling API: $path with data: $data");
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      print("API Response: ${response.data}");
      print(response);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // PUT method
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // DELETE method
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParams,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  void _handleError(DioException error) {
    String errorMessage = '';
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleBadResponse(error);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request canceled';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'Unknown error';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad certificate';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Connection error';
        break;
    }
    throw ApiException(errorMessage);
  }

  // Handle bad response errors
  String _handleBadResponse(DioException error) {
    if (error.response != null) {
      switch (error.response!.statusCode) {
        case 400:
          return 'Bad Request';
        case 401:
          return 'Unauthorized';
        case 403:
          return 'Forbidden';
        case 404:
          return 'Not Found';
        case 500:
          return 'Internal Server Error';
        default:
          return 'Unexpected error occurred';
      }
    }
    return 'No response from server';
  }
}

// Custom API Exception
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
