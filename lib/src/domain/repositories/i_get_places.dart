import '../entities/awesome_place_entity.dart';
import '../../error/faliures/i_faliure.dart';
import 'package:dartz/dartz.dart';

abstract class IGetPlacesRepository {
  Future<Either<Faliure, AwesomePlacesEntity>> call(
      {required ParmSearchEntity parm});
}

class ParmSearchEntity {
  final String value;
  final String key;

  ParmSearchEntity({required this.key, required this.value});
}
