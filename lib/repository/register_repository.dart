// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pupuk_frontend/constants.dart';

class RegisterRepository {
  final Dio _dio = Dio();
  final String _url = AppConfig.url;
  final LocalStorage _localStorage = LocalStorage(AppConfig.localStorageName);

  Future<int> register(dynamic data) async {
    Map<String, String> _headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Response response = await _dio.post(
      '$_url/register',
      data: data,
      options: Options(
        headers: _headers,
        validateStatus: (statusCode) {
          if (statusCode == null) {
            return false;
          } else if (statusCode == 422 || statusCode == 401) {
            return true;
          } else {
            return statusCode >= 200 && statusCode < 300;
          }
        },
      ),
    );
    var res = response.data;
    print(res);
    if (res['code'] == 201) {
      return 201;
    } else if (res['code'] == 422) {
      return 422;
    } else {
      return 401;
    }
  }
}
