import 'package:awesome_place_search/src/domain/entities/awesome_place_entity.dart';
import 'package:awesome_place_search/src/domain/repositories/i_get_places.dart';
import 'package:awesome_place_search/src/core/error/faliures/i_faliure.dart';
import 'package:dartz/dartz.dart';

abstract class Usecase<Type, Parm> {
  Future<Either<Faliure, Type>> call({required Parm parm});
}

class GetPlacesUsecase
    extends Usecase<AwesomePlacesSearchEntity, ParmSearchEntity> {
  final IGetPlacesRepository repository;

  GetPlacesUsecase({required this.repository});
  @override
  Future<Either<Faliure, AwesomePlacesSearchEntity>> call(
      {required ParmSearchEntity parm}) {
    return repository.call(parm: parm);
  }
}