import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/domain/entities/awesome_place_entity.dart';
import 'package:awesome_place_search/src/domain/entities/lat_lng_entity.dart';
import 'package:awesome_place_search/src/domain/entities/param_search_entity.dart';
import 'package:awesome_place_search/src/domain/repositories/i_get_search_repository.dart';
import 'package:dartz/dartz.dart';

part 'get_places_usecase.dart';
part 'get_lat_lng_usecase.dart';

abstract class UseCase<Type, Param> {
  Future<Either<Failure, Type>> call({required Param param});
}
