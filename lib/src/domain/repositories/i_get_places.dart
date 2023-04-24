import 'package:awesome_place_search/src/domain/entities/lat_lng_entity.dart';

import '../entities/awesome_place_entity.dart';
import '../../core/error/failures/i_failure.dart';
import 'package:dartz/dartz.dart';

abstract class IGetPlacesRepository {
  Future<Either<Failure, AwesomePlacesSearchEntity>> call(
      {required ParmSearchEntity parm});
}

abstract class IGetLatLngRepository {
  Future<Either<Failure, LatLngEntity>> call({required String placeId});
}

class ParmSearchEntity {
  final String value;
  final String key;

  ParmSearchEntity({required this.key, required this.value});
}
