// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pupuk_frontend/constants.dart';

class LoginRepository {
  final Dio _dio = Dio();
  final String _url = AppConfig.url;
  final LocalStorage _localStorage = LocalStorage(AppConfig.localStorageName);

  Future<int> login(dynamic data) async {
    Map<String, String> _headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Response response = await _dio.post('$_url/login',
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
            }));
    var res = response.data;
    if (res['code'] == 200) {
      var res = response.data;
      await _localStorage.setItem('X-Auth-Token', res['result']['token']);
      await _localStorage.setItem('isLogin', true);
      return 200;
    } else if (res['code'] == 401 && res['result']['token'] == null) {
      await _localStorage.setItem('X-Auth-Token', null);
      await _localStorage.setItem('isLogin', false);
      return 401;
    } else {
      await _localStorage.setItem('X-Auth-Token', null);
      await _localStorage.setItem('isLogin', false);
      return 422;
    }
  }
}
