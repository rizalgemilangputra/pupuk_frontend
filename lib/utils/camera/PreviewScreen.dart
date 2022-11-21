import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pupuk_frontend/utils/camera/Camera.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({Key? key, required this.imgPath}) : super(key: key);
  final XFile imgPath;

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Image.file(File(widget.imgPath.path), fit: BoxFit.cover),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CameraPage())),
                icon: const Icon(Icons.rotate_left),
                label: const Text("PHOTO ULANG")),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  //kirim absensi
                  uploadPhoto();
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text("KIRIM SEKARANG")),
          ],
        ));
  }

  uploadPhoto() async {
    // var request = http.MultipartRequest(
    //     'POST', Uri.parse('http://api.sobatcoding.com/upload.php'));

    // request.files.add(http.MultipartFile(
    //     'file',
    //     File(widget.imgPath.path).readAsBytes().asStream(),
    //     File(widget.imgPath.path).lengthSync(),
    //     filename: widget.imgPath.path.split("/").last));
    // var res = await request.send();

    // var responseBytes = await res.stream.toBytes();
    // var responseString = utf8.decode(responseBytes);

    // debugPrint("response: " + responseString.toString());
  }
}
