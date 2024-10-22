import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_image/data/api/api_service.dart';
import 'package:upload_image/provider/upload_provider.dart';
import 'provider/home_provider.dart';
import 'screen/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadProvider(apiService: ApiService()),
        ),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
