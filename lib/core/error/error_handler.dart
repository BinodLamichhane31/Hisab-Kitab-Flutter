import 'package:dio/dio.dart';
import 'package:hisab_kitab/core/error/failure.dart';

Failure handleDioError(DioException e) {
  if (e.type == DioExceptionType.badResponse) {
    final statusCode = e.response?.statusCode;

    if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
      final responseData = e.response!.data as Map<String, dynamic>;
      if (responseData.containsKey('message')) {
        return ApiFailure(
          message: responseData['message'] as String,
          statusCode: statusCode,
        );
      }
    }

    return ApiFailure(
      message: 'Received an error from the server (Code: $statusCode).',
      statusCode: statusCode,
    );
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return ApiFailure(
        message:
            'Connection timed out. Please check your internet connection and try again.',
      );
    case DioExceptionType.connectionError:
      return ApiFailure(
        message: 'No internet connection or the server is unavailable.',
      );
    case DioExceptionType.cancel:
      return ApiFailure(message: 'The request was cancelled.');
    default:
      return ApiFailure(
        message: 'An unexpected network error occurred. Please try again.',
      );
  }
}
