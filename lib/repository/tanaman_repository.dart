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
        data.add(TanamanModel.fromJson(v));
      });
      return data;
    } catch (error) {
      //error, stacktrace
      // print("Exception occured: $error stackTrace: $stacktrace");
      // return TanamanModel.withError("Data not found / Connection issue");
      throw Exception("Data not found / Connection issue => $error");
    }
  }
}

class NetworkError extends Error {}
