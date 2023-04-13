import 'package:awesome_place_search/src/domain/entities/lat_lng_entity.dart';

import '../entities/awesome_place_entity.dart';
import '../../core/error/faliures/i_faliure.dart';
import 'package:dartz/dartz.dart';

abstract class IGetPlacesRepository {
  Future<Either<Faliure, AwesomePlacesSearchEntity>> call(
      {required ParmSearchEntity parm});
}

abstract class IGetLatLngRepository {
  Future<Either<Faliure, LatLngEntity>> call({required String placeId});
}

class ParmSearchEntity {
  final String value;
  final String key;

  ParmSearchEntity({required this.key, required this.value});
}
