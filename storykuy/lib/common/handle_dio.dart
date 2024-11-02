import 'package:dio/dio.dart';

String handleDioError(DioException error) {
  String errorMessage;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      errorMessage = "Connection timeout. Please try again later.";
      break;
    case DioExceptionType.sendTimeout:
      errorMessage = "Request timeout. Please try again later.";
      break;
    case DioExceptionType.receiveTimeout:
      errorMessage = "Response timeout. Please try again later.";
      break;
    case DioExceptionType.badResponse:
      if (error.response != null) {
        switch (error.response?.statusCode) {
          case 400:
            errorMessage = "Bad request. Please check the data you sent.";
            break;
          case 401:
            errorMessage = "Unauthorized. Please log in again.";
            break;
          case 403:
            errorMessage = "Access denied.";
            break;
          case 404:
            errorMessage = "Resource not found.";
            break;
          case 500:
            errorMessage = "Server error. Please try again later.";
            break;
          default:
            errorMessage =
                "Something went wrong!: ${error.response?.statusMessage}";
        }
      } else {
        errorMessage = "Something unexpected went wrong!";
      }
      break;
    case DioExceptionType.cancel:
      errorMessage = "Request was canceled.";
      break;
    case DioExceptionType.connectionError:
      errorMessage = "No internet connection.";
      break;
    case DioExceptionType.badCertificate:
      errorMessage = "Something went wrong!";
      break;
    case DioExceptionType.unknown:
      errorMessage = "Something went wrong!";
      break;
  }
  return errorMessage;
}
