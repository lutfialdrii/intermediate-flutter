// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storykuy/common/result_state.dart';
import 'package:storykuy/common/common.dart';
import 'package:storykuy/provider/home_provider.dart';

class AddStoryScreen extends StatefulWidget {
  final Function() goBackToHome;

  const AddStoryScreen({
    super.key,
    required this.goBackToHome,
  });

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController descriptionController = TextEditingController();
  var isDescError = false;

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
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (context.read<HomeProvider>().imagePath == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content:
                                Text(AppLocalizations.of(context)!.errorImage),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: context.watch<HomeProvider>().uploadState ==
                              ResultState.loading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "UPLOAD",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    await provider.upload(newBytes, fileName, description);

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
