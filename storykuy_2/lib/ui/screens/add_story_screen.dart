import 'dart:io';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storykuy/common/result_state.dart';
import 'package:storykuy/common/common.dart';
import 'package:storykuy/provider/home_provider.dart';
import 'package:storykuy/ui/widgets/placemark_widget.dart';

import '../../router/page_manager.dart';

class AddStoryScreen extends StatefulWidget {
  final Function() goBackToHome;
  final Function() goToPickLocation;

  const AddStoryScreen({
    super.key,
    required this.goBackToHome,
    required this.goToPickLocation,
  });

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController descriptionController = TextEditingController();
  var isDescError = false;
  LatLng? locationPicked;

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("New Story"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                context.watch<HomeProvider>().imagePath == null
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: const Icon(
                          size: 64,
                          Icons.add_photo_alternate,
                          color: Colors.green,
                        ),
                      )
                    : _showImage(),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _onCameraView();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            AppLocalizations.of(context)!.camera,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _onGalleryView();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            AppLocalizations.of(context)!.gallery,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.desc,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1.5,
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintStyle: const TextStyle(color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Visibility(
                  visible: isDescError,
                  child: Text(
                    AppLocalizations.of(context)!.errorDesc,
                    style: const TextStyle(fontSize: 10, color: Colors.red),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final pageManager = context.read<PageManager>();
                      widget.goToPickLocation();
                      setState(() async {
                        locationPicked = await pageManager.waitForResult();
                      });
                    },
                    label: const Text("Share Your Location?"),
                    icon: const Icon(Icons.share_location_outlined),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                if (locationPicked != null)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      "Story Location",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                if (locationPicked != null)
                  FutureBuilder(
                    future: showLocation(locationPicked!),
                    builder: (context, snapshot) => snapshot.data!,
                  )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            if (context.read<HomeProvider>().imagePath == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(AppLocalizations.of(context)!.errorImage),
                ),
              );
            } else if (descriptionController.text.isEmpty) {
              setState(() {
                isDescError = true;
              });
            } else {
              _onUpload(descriptionController.text);
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                context.watch<HomeProvider>().uploadState == ResultState.loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "UPLOAD",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
          ),
        ),
      ),
    );
  }

  Future<PlacemarkWidget> showLocation(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];

    return PlacemarkWidget(placemark: place);
  }

  _onGalleryView() async {
    final provider = context.read<HomeProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<HomeProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _showImage() {
    final imagePath = context.read<HomeProvider>().imagePath;

    return Align(
      alignment: Alignment.center,
      child: kIsWeb
          ? Image.network(
              height: MediaQuery.of(context).size.height * 0.3,
              imagePath.toString(),
              fit: BoxFit.contain,
            )
          : Image.file(
              height: MediaQuery.of(context).size.height * 0.3,
              File(imagePath.toString()),
              fit: BoxFit.contain,
            ),
    );
  }

  _onUpload(String description) async {
    final provider = context.read<HomeProvider>();
    final imagePath = provider.imagePath;
    final imageFile = provider.imageFile;

    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await provider.compressImage(bytes);
    if (locationPicked == null) {
      await provider.upload(newBytes, fileName, description);
    } else {
      await provider.uploadWithLocation(
        newBytes,
        fileName,
        description,
        locationPicked!.latitude.toString(),
        locationPicked!.longitude.toString(),
      );
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(provider.message)));
    if (provider.uploadState == ResultState.loaded) {
      provider.setImageFile(null);
      provider.setImagePath(null);
      provider.fetchStories();
      widget.goBackToHome();
    }
  }
}
