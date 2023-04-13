import 'package:awesome_place_search/src/core/error/exceptions/server_exception.dart';
import 'package:awesome_place_search/src/data/models/lat_lng_model.dart';
import 'package:google_maps_webservice/places.dart';

abstract class IGetLatLngDataSource {
  Future<LatLngModel> call({required String parm});
}

class GetLatLngDataSource implements IGetLatLngDataSource {
  final String key;

  GetLatLngDataSource({required this.key}) {
    _places = GoogleMapsPlaces(apiKey: key);
  }

  late GoogleMapsPlaces _places;

  @override
  Future<LatLngModel> call({required String parm}) async {
    try {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(parm);
      final LatLngModel result = LatLngModel(
        latModel: detail.result.geometry!.location.lat,
        lngModel: detail.result.geometry!.location.lng,
      );
      return result;
    } catch (e) {
      throw ServerException();
    }
  }
}
