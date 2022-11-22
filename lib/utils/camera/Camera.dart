import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import 'dart:convert' as convert;

import 'package:pupuk_frontend/repository/tanaman_repository.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? cameraController;
  List? cameras;
  int? selectedCameraIndex;

  @override
  void initState() {
    super.initState();

    availableCameras().then((value) {
      cameras = value;
      if (cameras!.isNotEmpty) {
        selectedCameraIndex = 0;
        initCamera(cameras![selectedCameraIndex!]).then((_) {});
      } else {
        debugPrint("Camera not found");
      }
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future initCamera(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController!.dispose();
    }

    cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    cameraController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    if (cameraController!.value.hasError) {
      debugPrint("Error Camera");
    }

    try {
      await cameraController!.initialize();
    } catch (e) {
      debugPrint("Error Camera $e");
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: cameraPreview(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black,
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.only(bottom: 20),
                child: cameraControl(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cameraPreview() {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Text("Loading ..");
    }
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    final double mirror = selectedCameraIndex == 1 ? math.pi : 0;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(mirror),
      child: Transform.scale(
        scale: scale,
        child: Center(
          child: Stack(
            children: [
              CameraPreview(cameraController!),
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cameraControl(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                onCapture(context);
              },
              // ignore: sort_child_properties_last
              child: const Icon(Icons.camera),
              backgroundColor: Colors.redAccent,
            )
          ],
        ),
      ),
    );
  }

  getCameraLensIcon(lensDirection) {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return CupertinoIcons.photo_camera;
      default:
        return Icons.device_unknown;
    }
  }

  onSwitchCamera() {
    selectedCameraIndex = selectedCameraIndex! < cameras!.length - 1
        ? selectedCameraIndex! + 1
        : 0;
    CameraDescription selectedCamera = cameras![selectedCameraIndex!];
    initCamera(selectedCamera);
  }

  onCapture(context) async {
    try {
      await cameraController!.takePicture().then((value) async {
        List<int> photoAsBytes = await value.readAsBytes();
        String photoAsBase64 = convert.base64Encode(photoAsBytes);

        TanamanRepository tanamanRepository = TanamanRepository();
        Map<String, dynamic> data = {"umur": 8, "gambar": photoAsBase64};
        tanamanRepository.postTanaman(data).then((value) {
          if (value['code'] == 201) {
            Navigator.pop(context, true);
          }
        });
      });
    } catch (e) {
      debugPrint('error $e');
    }
  }
}
