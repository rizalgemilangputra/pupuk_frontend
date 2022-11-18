import 'package:flutter/material.dart';
import 'package:pupuk_frontend/constants.dart';
import 'package:pupuk_frontend/utils/camera/Camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Pupuk'),
        backgroundColor: AppCollors.appBar,
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: _gridView(),
          ),
          onWillPop: () => _onBackButtonDoubleClicked(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CameraPage())),
        backgroundColor: Colors.green,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  GridView _gridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2.2,
      ),
      itemCount: 10,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/home/detail');
          },
          child: Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              children: [
                Hero(
                  tag: 'homeHero-$index',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: Image.asset('assets/images/sawit.jpeg'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        'Update :',
                        style: TextStyle(
                          color: Color.fromARGB(137, 27, 27, 27),
                        ),
                      ),
                      const Text('01-01-2022'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onBackButtonDoubleClicked(BuildContext context) async {
    final backPressedTime = DateTime.now();
    final difference = DateTime.now().difference(backPressedTime);

    if (difference >= const Duration(seconds: 3)) {
      toast(context, 'Tekan Kembali Untuk Keluar');
      return false;
    } else {
      return true;
    }
  }

  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
