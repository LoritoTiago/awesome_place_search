import 'dart:async';

import '../models/awesome_place_model.dart';
import '../../core/error/exceptions/network_exception.dart';
import '../../core/error/exceptions/server_exception.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_webservice/places.dart';

abstract class IGetPlacesRemoteDataSource {
  Future<AwesomePlacesSearchModel> call({required ParmSearchModel parm});
}

class GetPlacesRemoteDataSource implements IGetPlacesRemoteDataSource {
  final String key;
  late GoogleMapsPlaces _places;

  GetPlacesRemoteDataSource({required this.key}) {
    _places = GoogleMapsPlaces(apiKey: key);
  }
  @override
  Future<AwesomePlacesSearchModel> call({required ParmSearchModel parm}) async {
    try {
      var url =
          Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
        "input": parm.value,
        "key": parm.key,
      });
      var res =
          await http.Client().get(url).timeout(const Duration(seconds: 20));
      if (res.statusCode == 200) {
        final result = awesomePlacesModelFromJson(res.body);

        // for (var element in result.predictions!) {
        //   PlacesDetailsResponse detail =
        //       await _places.getDetailsByPlaceId(element.placeId!);
        //   element.latitude = detail.result.geometry!.location.lat;
        //   element.longitude = detail.result.geometry!.location.lng;
        // }
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