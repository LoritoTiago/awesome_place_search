import 'dart:async';
import 'dart:developer';

import 'package:awesome_place_search/src/core/error/exceptions/key_empty_exception.dart';

import '../models/awesome_place_model.dart';
import '../../core/error/exceptions/network_exception.dart';
import '../../core/error/exceptions/server_exception.dart';
import 'package:http/http.dart' as http;

abstract class IGetPlacesRemoteDataSource {
  Future<AwesomePlacesSearchModel> call({required ParamSearchModel param});
}

class GetPlacesRemoteDataSource implements IGetPlacesRemoteDataSource {
  final String key;

  GetPlacesRemoteDataSource({required this.key});
  @override
  Future<AwesomePlacesSearchModel> call({required ParamSearchModel param}) async {
    log(param.key);
    if (param.key.isEmpty || param.key.contains(' ')) {
      throw KeyEmptyException();
    } else {
      try {
        var url = Uri.https(
            "maps.googleapis.com", "maps/api/place/autocomplete/json", {
          "input": param.value,
          "key": param.key,
        });
        var res =
            await http.Client().get(url).timeout(const Duration(seconds: 20));
        if (res.statusCode == 200) {
          final result = awesomePlacesModelFromJson(res.body);

          return result;
        }
        throw ServerException();
      } on TimeoutException {
        throw NetworkException();
      } catch (e) {
        throw ServerException();
      }
    }
  }
}
