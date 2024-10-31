import 'package:dio/dio.dart';

String handleDioError(DioException error) {
  String errorMessage;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      errorMessage = "Koneksi timeout. Coba lagi nanti.";
      break;
    case DioExceptionType.sendTimeout:
      errorMessage = "Request timeout. Coba lagi nanti.";
      break;
    case DioExceptionType.receiveTimeout:
      errorMessage = "Response timeout. Coba lagi nanti.";
      break;
    case DioExceptionType.badResponse:
      if (error.response != null) {
        switch (error.response?.statusCode) {
          case 400:
            errorMessage = "Bad request. Cek data yang Anda kirim.";
            break;
          case 401:
            errorMessage = "Unauthorized. Silakan login ulang.";
            break;
          case 403:
            errorMessage = "Akses ditolak.";
            break;
          case 404:
            errorMessage = "Resource tidak ditemukan.";
            break;
          case 500:
            errorMessage = "Server error. Coba lagi nanti.";
            break;
          default:
            errorMessage =
                "Terjadi kesalahan: ${error.response?.statusMessage}";
        }
      } else {
        errorMessage = "Terjadi kesalahan tak terduga.";
      }
      break;
    case DioExceptionType.cancel:
      errorMessage = "Request dibatalkan.";
      break;
    case DioExceptionType.connectionError:
      errorMessage = "Tidak ada koneksi internet.";
      break;
    case DioExceptionType.badCertificate:
      errorMessage = "Terjadi Kesalahan";
      break;
    case DioExceptionType.unknown:
      errorMessage = "Terjadi Kesalahan";
      break;
  }
  return errorMessage;
}
