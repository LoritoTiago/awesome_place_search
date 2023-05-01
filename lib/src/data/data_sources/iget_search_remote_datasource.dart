import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:awesome_place_search/src/data/models/lat_lng_model.dart';

abstract class IGetSearchRemoteDataSource {
  Future<LatLngModel> getLatLng({required String param});

  Future<AwesomePlacesSearchModel> getPlace({required ParamSearchModel param});
}
