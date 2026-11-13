import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../core/api_config.dart';

class DogService {
  Future<List<dynamic>?> fetchDogs({String? breedName}) async {
    try {
      final Map<String, dynamic> params = {};
      if (breedName != null && breedName.isNotEmpty) {
        params['name'] = breedName;
      }

      final response = await GetIt.instance<Dio>().get(
        'dogs',
        queryParameters: params,
      );
      return response.data;
    } catch (e) {
      print("Ошибка запроса: $e");
      return null;
    }
  }
}