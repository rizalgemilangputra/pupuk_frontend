import 'package:dio/dio.dart';
import 'package:pupuk_frontend/constants.dart';

class RegisterRepository {
  final Dio _dio = Dio();
  final String _url = AppConfig.url;

  Future<dynamic> register(dynamic data) async {
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    Response response = await _dio.post(
      '$_url/register',
      data: data,
      options: Options(
        headers: headers,
        validateStatus: (_) => true,
      ),
    );
    return response;
  }
}
