// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:pupuk_frontend/constants.dart';
import 'package:pupuk_frontend/models/tanaman_model.dart';

class TanamanRepository {
  final Dio _dio = Dio();
  final String _url = AppConfig.url;

  final LocalStorage localStorage = LocalStorage(AppConfig.localStorageName);

  Future<List<TanamanModel>> fetchTanamanList() async {
    try {
      _dio.options.headers['content-Type'] = 'application/json';
      _dio.options.headers["X-Auth-Token"] =
          localStorage.getItem('X-Auth-Token');

      Response response = await _dio.get('$_url/plants');
      List<TanamanModel> data = [];
      response.data.forEach((v) {
        print(v);
        data.add(TanamanModel.fromJson(v));
      });
      return data;
    } catch (error, stacktrace) {
      throw Exception("Data not found / Connection issue => $error");
    }
  }

  Future<dynamic> postTanaman(data) async {
    try {
      _dio.options.headers['content-Type'] = 'application/json';
      _dio.options.headers["X-Auth-Token"] =
          localStorage.getItem('X-Auth-Token');
      Response response = await _dio.post('$_url/plant', data: data);
      var res = response.data;
      return res;
    } catch (error, stackTrace) {
      throw Exception(
          "Data not found / Connection issue => $error => $stackTrace");
    }
  }

  Future<dynamic> deleteTanaman(id) async {
    try {
      _dio.options.headers['content-Type'] = 'application/json';
      _dio.options.headers["X-Auth-Token"] =
          localStorage.getItem('X-Auth-Token');

      Map<String, dynamic> data = {"id": id};
      Response response = await _dio.post('$_url/delete-plant', data: data);
      print(response.data);
      return response.data;
    } catch (error) {}
  }
}

class NetworkError extends Error {}
