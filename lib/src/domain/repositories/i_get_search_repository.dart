import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/domain/entities/lat_lng_entity.dart';
import 'package:awesome_place_search/src/domain/entities/param_search_entity.dart';
import '../entities/awesome_place_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IGetSearchRepository {
  Future<Either<Failure, LatLngEntity>> getLatLng({required String placeId});
  Future<Either<Failure, AwesomePlacesSearchEntity>> getPlace({required ParamSearchEntity param});
}
