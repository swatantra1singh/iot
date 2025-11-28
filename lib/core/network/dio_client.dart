import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

/// Creates and configures a Dio instance for HTTP requests.
///
/// This client is configured with:
/// - Base URL from [ApiConstants]
/// - Connection and receive timeouts
/// - Logging interceptor (debug only)
/// - Error handling interceptor
class DioClient {
  DioClient._();

  static Dio? _instance;

  /// Returns a singleton Dio instance.
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  /// Creates a new Dio instance with default configuration.
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      _createLoggingInterceptor(),
      _createErrorInterceptor(),
    ]);

    return dio;
  }

  /// Creates a logging interceptor for debugging.
  static Interceptor _createLoggingInterceptor() {
    return LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      logPrint: (object) {
        // Only log in debug mode
        assert(() {
          // ignore: avoid_print
          print(object);
          return true;
        }());
      },
    );
  }

  /// Creates an error handling interceptor.
  static Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        // Transform DioException to more specific error types if needed
        // For now, just pass through
        handler.next(error);
      },
    );
  }

  /// Creates a new Dio instance with custom base URL.
  ///
  /// Useful for connecting to different API endpoints or device-specific URLs.
  static Dio createCustomClient(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      _createLoggingInterceptor(),
      _createErrorInterceptor(),
    ]);

    return dio;
  }

  /// Adds an authorization header to the default Dio instance.
  static void setAuthToken(String token) {
    instance.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Removes the authorization header from the default Dio instance.
  static void clearAuthToken() {
    instance.options.headers.remove('Authorization');
  }
}
