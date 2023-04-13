import 'package:awesome_place_search/src/domain/entities/lat_lng_entity.dart';

class LatLngModel extends LatLngEntity {
  final double lat;
  final double lng;
  LatLngModel({required this.lat, required this.lng})
      : super(lat: lat, lng: lng);
}
