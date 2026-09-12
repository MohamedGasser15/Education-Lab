import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/services/auth_storage_service.dart';
import 'package:mobile/core/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NetworkStatus { connected, networkError, serverError }

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  const Failure(this.message, {this.error});
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  late final dio.Dio _dio;

  ApiClient._internal() {
    _dio = _createDio();
  }

  static const Duration defaultTimeout = Duration(seconds: 30);
  static const int defaultRetries = 2;

  static final ValueNotifier<NetworkStatus> networkStatus =
      ValueNotifier<NetworkStatus>(NetworkStatus.connected);

  static bool get isConnected => networkStatus.value == NetworkStatus.connected;

  static final Map<String, ({dynamic data, DateTime expiry})> _memoryCache = {};

  /// Clears in-memory HTTP response cache.
  static void clearCache() {
    _memoryCache.clear();
  }

  dio.Dio _createDio() {
    final d = dio.Dio(
      dio.BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: dio.ResponseType.plain,
        validateStatus: (_) => true,
      ),
    );

    d.interceptors.addAll([
      _RequestInterceptor(),
      _SanitizingLogInterceptor(),
    ]);

    return d;
  }

  Future<NetworkStatus> checkConnectivity() async {
    try {
      final response = await _dio.get(
        ApiConstants.publicStats,
        options: dio.Options(receiveTimeout: const Duration(seconds: 5)),
      );
      if (response.statusCode == 200) {
        networkStatus.value = NetworkStatus.connected;
        return NetworkStatus.connected;
      } else if (response.statusCode! >= 500) {
        networkStatus.value = NetworkStatus.serverError;
        return NetworkStatus.serverError;
      }
    } catch (e) {
      if (_isNetworkError(e)) {
        networkStatus.value = NetworkStatus.networkError;
        return NetworkStatus.networkError;
      }
    }
    return networkStatus.value;
  }

  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    int retries = defaultRetries,
    Duration timeout = defaultTimeout,
    Duration? cacheDuration,
  }) async {
    final cacheKey = '$url?${queryParameters ?? {}}';
    if (cacheDuration != null) {
      final cached = _memoryCache[cacheKey];
      if (cached != null && DateTime.now().isBefore(cached.expiry)) {
        return cached.data;
      }
    }

    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        final response = await _dio.get(
          url,
          queryParameters: queryParameters,
          options: dio.Options(
            sendTimeout: timeout,
            receiveTimeout: timeout,
            headers: headers,
          ),
        );
        if (response.statusCode == 200) {
          networkStatus.value = NetworkStatus.connected;
          final decoded = _tryDecode(response.data);
          if (cacheDuration != null) {
            _memoryCache[cacheKey] = (
              data: decoded,
              expiry: DateTime.now().add(cacheDuration),
            );
          }
          return decoded;
        }
        throw ApiException(
          response.statusCode ?? 0,
          response.data?.toString() ?? '',
        );
      } catch (e) {
        if (e is ApiException) rethrow;
        if (_isNetworkError(e)) {
          if (attempt < retries) {
            await Future.delayed(Duration(seconds: 1 * (attempt + 1)));
            continue;
          }
          checkConnectivity();
        }
        rethrow;
      }
    }
    throw ApiException(0, 'Request failed after $retries retries');
  }

  Future<dynamic> post(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    int retries = defaultRetries,
    Duration timeout = defaultTimeout,
  }) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        final response = await _dio.post(
          url,
          data: body,
          options: dio.Options(
            sendTimeout: timeout,
            receiveTimeout: timeout,
            contentType: dio.Headers.jsonContentType,
            headers: headers,
          ),
        );
        if (response.statusCode == 200) {
          networkStatus.value = NetworkStatus.connected;
          return _tryDecode(response.data);
        }
        throw ApiException(
          response.statusCode ?? 0,
          response.data?.toString() ?? '',
        );
      } catch (e) {
        if (e is ApiException) rethrow;
        if (_isNetworkError(e)) {
          if (attempt < retries) {
            await Future.delayed(Duration(seconds: 1 * (attempt + 1)));
            continue;
          }
          checkConnectivity();
        }
        rethrow;
      }
    }
    throw ApiException(0, 'POST failed after $retries retries');
  }

  Future<dio.Response> postRaw(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.post(
        url,
        data: body,
        options: dio.Options(
          contentType: dio.Headers.jsonContentType,
          headers: headers,
        ),
      );
    } catch (e) {
      if (_isNetworkError(e)) {
        checkConnectivity();
      }
      rethrow;
    }
  }

  Future<dio.Response> getRaw(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.get(
        url,
        queryParameters: queryParameters,
        options: dio.Options(headers: headers),
      );
    } catch (e) {
      if (_isNetworkError(e)) {
        checkConnectivity();
      }
      rethrow;
    }
  }

  Future<Result<dynamic>> getSafe(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    int retries = defaultRetries,
    Duration timeout = defaultTimeout,
    Duration? cacheDuration,
  }) async {
    try {
      final data = await get(
        url,
        queryParameters: queryParameters,
        headers: headers,
        retries: retries,
        timeout: timeout,
        cacheDuration: cacheDuration,
      );
      return Success(data);
    } catch (e) {
      return Failure(e.toString(), error: e);
    }
  }

  Future<dynamic> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    int retries = defaultRetries,
    Duration timeout = defaultTimeout,
  }) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        final response = await _dio.put(
          url,
          data: body,
          options: dio.Options(
            sendTimeout: timeout,
            receiveTimeout: timeout,
            contentType: dio.Headers.jsonContentType,
            headers: headers,
          ),
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          networkStatus.value = NetworkStatus.connected;
          return _tryDecode(response.data);
        }
        throw ApiException(
          response.statusCode ?? 0,
          response.data?.toString() ?? '',
        );
      } catch (e) {
        if (e is ApiException) rethrow;
        if (_isNetworkError(e)) {
          if (attempt < retries) {
            await Future.delayed(Duration(seconds: 1 * (attempt + 1)));
            continue;
          }
          checkConnectivity();
        }
        rethrow;
      }
    }
    throw ApiException(0, 'PUT failed after $retries retries');
  }

  Future<Result<dynamic>> putSafe(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    int retries = defaultRetries,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      final data = await put(
        url,
        body: body,
        headers: headers,
        retries: retries,
        timeout: timeout,
      );
      return Success(data);
    } catch (e) {
      return Failure(e.toString(), error: e);
    }
  }

  Future<Result<dynamic>> postFormDataSafe(
    String url, {
    required dio.FormData formData,
    Map<String, dynamic>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(
          sendTimeout: timeout,
          receiveTimeout: timeout,
          headers: headers,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        networkStatus.value = NetworkStatus.connected;
        return Success(_tryDecode(response.data));
      }
      return Failure(
        'Upload failed with status ${response.statusCode}: ${response.data}',
      );
    } catch (e) {
      return Failure(e.toString(), error: e);
    }
  }

  Future<Result<dynamic>> postSafe(
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
    int retries = defaultRetries,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      final data = await post(
        url,
        body: body,
        headers: headers,
        retries: retries,
        timeout: timeout,
      );
      return Success(data);
    } catch (e) {
      return Failure(e.toString(), error: e);
    }
  }

  Future<dynamic> delete(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, dynamic>? headers,
    int retries = defaultRetries,
    Duration timeout = defaultTimeout,
  }) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        final response = await _dio.delete(
          url,
          queryParameters: queryParameters,
          data: body,
          options: dio.Options(
            sendTimeout: timeout,
            receiveTimeout: timeout,
            contentType: dio.Headers.jsonContentType,
            headers: headers,
          ),
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          networkStatus.value = NetworkStatus.connected;
          return _tryDecode(response.data);
        }
        throw ApiException(
          response.statusCode ?? 0,
          response.data?.toString() ?? '',
        );
      } catch (e) {
        if (e is ApiException) rethrow;
        if (_isNetworkError(e)) {
          if (attempt < retries) {
            await Future.delayed(Duration(seconds: 1 * (attempt + 1)));
            continue;
          }
          checkConnectivity();
        }
        rethrow;
      }
    }
    throw ApiException(0, 'DELETE failed after $retries retries');
  }

  Future<Result<dynamic>> deleteSafe(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, dynamic>? headers,
    int retries = defaultRetries,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      final data = await delete(
        url,
        queryParameters: queryParameters,
        body: body,
        headers: headers,
        retries: retries,
        timeout: timeout,
      );
      return Success(data);
    } catch (e) {
      return Failure(e.toString(), error: e);
    }
  }

  dynamic _tryDecode(dynamic data) {
    if (data is String && data.isNotEmpty) {
      try {
        return json.decode(data);
      } catch (_) {
        return data;
      }
    }
    return data;
  }

  static bool _isNetworkError(dynamic error) {
    String s;
    if (error is dio.DioException) {
      s = (error.error?.toString() ?? error.message ?? error.toString())
          .toLowerCase();
    } else {
      s = error.toString().toLowerCase();
    }
    return s.contains('socketexception') ||
        s.contains('network is unreachable') ||
        s.contains('failed host lookup') ||
        s.contains('httpexception') ||
        s.contains('clientexception') ||
        s.contains('connection closed') ||
        s.contains('connection failed') ||
        s.contains('software caused connection abort') ||
        s.contains('connection timed out') ||
        s.contains('handshakeexception');
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String responseBody;

  const ApiException(this.statusCode, this.responseBody);

  @override
  String toString() => 'ApiException($statusCode): $responseBody';
}

class _RequestInterceptor extends dio.Interceptor {
  @override
  void onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';
    try {
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString('language') ?? 'ar';
      if (!options.headers.containsKey('Accept-Language')) {
        options.headers['Accept-Language'] = lang;
      }

      final token = await AuthStorageService.getAccessToken();
      if (token != null &&
          token.isNotEmpty &&
          !options.headers.containsKey('Authorization')) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {}
    handler.next(options);
  }
}

class _SanitizingLogInterceptor extends dio.Interceptor {
  @override
  void onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      final buffer = StringBuffer();
      buffer.writeln('*** Request ***');
      buffer.writeln('uri: ${options.uri}');
      buffer.writeln('method: ${options.method}');
      
      final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
      if (sanitizedHeaders.containsKey('Authorization')) {
        sanitizedHeaders['Authorization'] = 'Bearer ***REDACTED***';
      }
      if (sanitizedHeaders.containsKey('Cookie')) {
        sanitizedHeaders['Cookie'] = '***REDACTED***';
      }
      buffer.writeln('headers: $sanitizedHeaders');

      if (options.data != null) {
        buffer.writeln('data: ${AppLogger.sanitize(options.data.toString())}');
      }
      AppLogger.d(buffer.toString().trim(), tag: 'DIO');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    dio.Response response,
    dio.ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      final buffer = StringBuffer();
      buffer.writeln('*** Response ***');
      buffer.writeln('uri: ${response.requestOptions.uri}');
      buffer.writeln('statusCode: ${response.statusCode}');
      if (response.data != null) {
        final text = response.data.toString();
        final preview = text.length > 500 ? '${text.substring(0, 500)}... [truncated]' : text;
        buffer.writeln('data: ${AppLogger.sanitize(preview)}');
      }
      AppLogger.d(buffer.toString().trim(), tag: 'DIO');
    }
    handler.next(response);
  }

  @override
  void onError(
    dio.DioException err,
    dio.ErrorInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      AppLogger.w(
        '*** DioException ***\nuri: ${err.requestOptions.uri}\nmessage: ${err.message}\nstatusCode: ${err.response?.statusCode}',
        tag: 'DIO',
      );
    }
    handler.next(err);
  }
}

