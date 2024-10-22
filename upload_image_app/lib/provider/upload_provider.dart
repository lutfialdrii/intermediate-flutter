import 'package:flutter/foundation.dart';
import 'package:upload_image/data/api/api_service.dart';
import 'package:upload_image/data/model/upload_response.dart';
import 'package:image/image.dart' as img;

class UploadProvider extends ChangeNotifier {
  final ApiService apiService;

  bool isUploading = false;
  String message = "";
  UploadResponse? uploadResponse;

  UploadProvider({required this.apiService});

  Future<void> upload(
      List<int> bytes, String fileName, String description) async {
    try {
      message = "";
      uploadResponse = null;
      isUploading = true;
      notifyListeners();

      uploadResponse =
          await apiService.uploadDocument(bytes, fileName, description);
      message = uploadResponse?.message ?? "success";
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      ///
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }
}
