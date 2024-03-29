import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  cameraPreview(),
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.yellow),
                      ),
                    ),
                  )
                ],
              ),
            ),
            cameraControl(context),
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
          child: CameraPreview(cameraController!),
        ),
      ),
    );
  }

  Widget cameraControl(context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: FloatingActionButton(
          child: const Icon(Icons.camera),
          onPressed: () => onCapture(context),
        ),
      ),
    );
  }

  onCapture(context) async {
    try {
      await cameraController!.takePicture().then((value) async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 15),
                    Text('Loading')
                  ],
                ),
              ),
            );
          },
        );
        List<int> photoAsBytes = await value.readAsBytes();
        String photoAsBase64 = convert.base64Encode(photoAsBytes);

        TanamanRepository tanamanRepository = TanamanRepository();
        Map<String, dynamic> data = {"umur": 8, "gambar": photoAsBase64};
        tanamanRepository.postTanaman(data).then((value) {
          if (value['code'] == 201) {
            Navigator.pop(context);
            Navigator.pop(context, true);
          } else if (value['code'] == 400) {
            Navigator.pop(context);
            Navigator.pop(context, false);
          }
        });
      });
    } catch (e) {
      debugPrint('error $e');
    }
  }
}
