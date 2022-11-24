import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pupuk_frontend/constants.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final LocalStorage localStorage = LocalStorage(AppConfig.localStorageName);

  @override
  void initState() {
    super.initState();
    startSplashSplashScreen();
  }

  startSplashSplashScreen() async {
    var isLogin = await localStorage.getItem('isLogin');
    print(isLogin);
    if (isLogin != null && isLogin) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Image.asset('assets/images/splashscreen.jpg'),
      ),
    );
  }
}
