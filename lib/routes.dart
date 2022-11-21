import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pupuk_frontend/constants.dart';
import 'package:pupuk_frontend/utils/camera/camera.dart';
import 'package:pupuk_frontend/views/auth/login.dart';
import 'package:pupuk_frontend/views/auth/register.dart';
import 'package:pupuk_frontend/views/home/detail.dart';
import 'package:pupuk_frontend/views/home/view.dart';
import 'package:pupuk_frontend/views/splashscreesn/view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final LocalStorage localStorage = LocalStorage(AppConfig.localStorageName);

    bool isLogin = localStorage.getItem('is_login') ?? false;
    var args = settings.arguments;

    if (isLogin) {
      switch (settings.name) {
        case '/home':
          return MaterialPageRoute(builder: (context) => const HomePage());
        case '/home/detail':
          return MaterialPageRoute(
              builder: (context) => DetailPage(tanaman: args));
        case '/camera':
          return MaterialPageRoute(builder: (context) => const CameraPage());
        case '/splashscreen':
          return MaterialPageRoute(
              builder: (context) => const SplashScreenPage());
        case '/login':
          return MaterialPageRoute(builder: (context) => const LoginPage());
        default:
          return _errorRoute();
      }
    } else {
      switch (settings.name) {
        case '/login':
          return MaterialPageRoute(builder: (context) => const LoginPage());
        case '/register':
          return MaterialPageRoute(builder: (context) => const RegisterPage());
        default:
          return MaterialPageRoute(builder: (context) => const LoginPage());
      }
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text('Error page')),
      );
    });
  }
}
