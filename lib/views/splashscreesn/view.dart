import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pupuk_frontend/constants.dart';
import 'package:pupuk_frontend/repository/login_repository.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final LocalStorage _localStorage = LocalStorage(AppConfig.localStorageName);
  final LoginRepository _loginRepository = LoginRepository();

  @override
  void initState() {
    super.initState();
    startSplashSplashScreen();
  }

  startSplashSplashScreen() async {
    await _localStorage.ready;
    var isLogin = await _localStorage.getItem('isLogin');
    var token = await _localStorage.getItem('X-Auth-Token');
    if (isLogin != null && isLogin) {
      int? cekToken = await _loginRepository.cekToken(token);
      if (cekToken == 200) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        await _localStorage.setItem('isLogin', false);
        await _localStorage.setItem('X-Auth-Token', null);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/login');
      }
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
