import 'dart:convert';

import 'package:awesome_place_search/src/core/error/exceptions/server_exception.dart';
import 'package:awesome_place_search/src/data/models/lat_lng_model.dart';
import 'package:http/http.dart' as http;

abstract class IGetLatLngDataSource {
  Future<LatLngModel> call({required String parm});
}

class GetLatLngDataSource implements IGetLatLngDataSource {
  final String key;

  GetLatLngDataSource({required this.key});

  @override
  Future<LatLngModel> call({required String parm}) async {
    try {
      var url =
          Uri.https("maps.googleapis.com", "maps/api/place/details/json", {
        "placeid": parm,
        "key": key,
      });
      var res =
          await http.Client().get(url).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        final value = json.decode(res.body);
        final body = value['result']['geometry']['location'];

        final LatLngModel result = LatLngModel(
          latModel: body['lat'],
          lngModel: body['lng'],
        );
        return result;
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  void testGetHttp() {
    // return httpClient.get(Uri.parse(url), headers: headers);
  }
}
