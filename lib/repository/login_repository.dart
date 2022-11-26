// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:pupuk_frontend/constants.dart';

class LoginRepository {
  final Dio _dio = Dio();
  final String _url = AppConfig.url;

  Future<dynamic> login(dynamic data) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Response response = await _dio.post(
      '$_url/login',
      data: data,
      options: Options(
        validateStatus: (_) => true,
        headers: headers,
      ),
    );

    dynamic res = response.data;
    return res;
  }

  Future<int> cekToken(token) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, dynamic> params = {"token": token};
    Response response = await _dio.get(
      '$_url/cek-token',
      queryParameters: params,
      options: Options(headers: headers),
    );
    return response.data['code'];
  }
}
