import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_maihomie_app/core/models/response.dart' as api_res;
import 'package:flutter_maihomie_app/ui/utils/constants.dart';

class ApiBase {
  var options = BaseOptions(
    baseUrl: "$localHost/api",
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );

  late Dio dio;

  baseApi() {
    dio = Dio(options);
    dio.options.headers['content-Type'] = 'application/json';
  }

  // var client = new Client();
  setToken(String bearerToken) async {
    dio.options.headers["authorization"] = "Bearer " + bearerToken;
    return;
  }

  api_res.Response castRes(Response res) {
    Map<String, dynamic> json = jsonDecode(res.toString());
    return api_res.Response.fromJson(json);
  }
}
