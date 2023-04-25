import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/domain/entities/lat_lng_entity.dart';
import '../entities/awesome_place_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IGetPlacesRepository {
  Future<Either<Failure, AwesomePlacesSearchEntity>> call(
      {required ParamSearchEntity param});
}

abstract class IGetLatLngRepository {
  Future<Either<Failure, LatLngEntity>> call({required String placeId});
}

class ParamSearchEntity {
  final String value;
  final String key;

  ParamSearchEntity({required this.key, required this.value});
}
