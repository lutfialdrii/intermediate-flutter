import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  bool _isBackCameraSelected = true;
  bool _isCameraInitialized = false;
  CameraController? controller;

  void onNewCameraSelected(CameraDescription cameraDesciption) async {
    final previousCameraController = controller;
    final cameraController = CameraController(
      cameraDesciption,
      ResolutionPreset.medium,
    );

    await previousCameraController?.dispose();

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print("Error initializing Camera : $e");
    }

    if (mounted) {
      setState(() {
        controller = cameraController;
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    onNewCameraSelected(widget.cameras.first);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ambil Gambar"),
          actions: [
            IconButton(
              onPressed: () {
                _onCameraSwitch();
              },
              icon: const Icon(Icons.cameraswitch),
            )
          ],
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _isCameraInitialized
                  ? CameraPreview(controller!)
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              Align(
                alignment: const Alignment(0, 0.95),
                child: _actionWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return FloatingActionButton(
      heroTag: "take-picture",
      tooltip: "Ambil gambar",
      onPressed: () {
        _onCameraButtonClick();
      },
      child: const Icon(Icons.camera_alt),
    );
  }

  void _onCameraButtonClick() async {
    final image = await controller?.takePicture();
    final navigator = Navigator.of(context);

    navigator.pop(image);
  }

  void _onCameraSwitch() {
    if (widget.cameras.length == 1) return;
    setState(() {
      _isCameraInitialized = false;
    });

    onNewCameraSelected(widget.cameras[_isBackCameraSelected ? 1 : 0]);

    setState(() {
      _isBackCameraSelected = !_isBackCameraSelected;
    });
  }
}
