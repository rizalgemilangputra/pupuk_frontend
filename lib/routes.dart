import 'package:flutter/material.dart';
import 'package:pupuk_frontend/utils/camera/camera.dart';
import 'package:pupuk_frontend/views/detail/detail.dart';
import 'package:pupuk_frontend/views/home/view.dart';
import 'package:pupuk_frontend/views/splashscreesn/view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/home/detail':
        return MaterialPageRoute(builder: (context) => const DetailPage());
      case '/camera':
        return MaterialPageRoute(builder: (context) => const CameraPage());
      case '/splashscreen':
        return MaterialPageRoute(
            builder: (context) => const SplashScreenPage());
      default:
        return _errorRoute();
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
