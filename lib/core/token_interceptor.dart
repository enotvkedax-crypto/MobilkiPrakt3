import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'api_config.dart';

class TokenInterceptor extends Interceptor{
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler){
    options.headers['X-Api-Key'] = ApiConfig.key;
    print("REQUST[${options.method}] => PATH: ${options.path}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler){
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler){
    print('ERROR[${err.message}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}