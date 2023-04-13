import 'package:awesome_place_search/src/domain/entities/awesome_place_entity.dart';
import 'package:awesome_place_search/src/error/faliures/i_faliure.dart';
import 'package:dartz/dartz.dart';

abstract class IGetPlaces {
  Future<Either<Faliure, AwesomePlacesEntity>> call({required ParmSearch parm});
}

class ParmSearch {}
