import 'package:dio/dio.dart';
import 'package:hisab_kitab/app/constant/api_endpoints.dart';
import 'package:hisab_kitab/app/shared_preferences/token_shared_prefs.dart';
import 'package:hisab_kitab/core/network/dio_error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  Dio get dio => _dio;

  ApiService(this._dio, this._tokenSharedPrefs) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final tokenResult = await _tokenSharedPrefs.getToken();

            tokenResult.fold((failure) {}, (token) {
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            });
            return handler.next(options);
          },
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }
}
