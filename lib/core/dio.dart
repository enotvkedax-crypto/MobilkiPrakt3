import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_config.dart';
import 'token_interceptor.dart';

final getIt = GetIt.instance;
class DependencyManager{
  static void initialize(){
    _setupDio();
  }

  static void _setupDio(){
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.url,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    dio.interceptors.add(TokenInterceptor());
    _configureLogging(dio);
    getIt.registerLazySingleton<Dio>(()=>dio);
  }

  static void _configureLogging(Dio dio){
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
}
