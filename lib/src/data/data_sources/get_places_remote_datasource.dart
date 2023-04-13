import 'dart:async';

import '../models/awesome_place_model.dart';
import '../../error/exceptions/network_exception.dart';
import '../../error/exceptions/server_exception.dart';
import 'package:http/http.dart' as http;

abstract class IGetPlacesRemoteDataSource {
  Future<AwesomePlacesModel> call({required ParmSearchModel parm});
}

class GetPlacesRemoteDataSource implements IGetPlacesRemoteDataSource {
  @override
  Future<AwesomePlacesModel> call({required ParmSearchModel parm}) async {
    try {
      var url =
          Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
        "input": parm.value,
        "key": parm.key,
      });
      var res =
          await http.Client().get(url).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        return awesomePlacesModelFromJson(res.body);
      }
      throw ServerException();
    } on TimeoutException {
      throw NetworkException();
    } catch (e) {
      throw ServerException();
    }
  }
}
