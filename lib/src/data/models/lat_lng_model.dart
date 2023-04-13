import 'package:awesome_place_search/src/domain/entities/lat_lng_entity.dart';

class LatLngModel extends LatLngEntity {
  final double latModel;
  final double lngModel;
  LatLngModel({required this.latModel, required this.lngModel})
      : super(lat: latModel, lng: lngModel);
}
