import 'package:awesome_place_search/src/domain/entities/awesome_place_entity.dart';
import 'package:awesome_place_search/src/domain/repositories/i_get_places.dart';
import 'package:awesome_place_search/src/error/faliures/i_faliure.dart';
import 'package:dartz/dartz.dart';

abstract class Usecase<Type, Parm> {
  Future<Either<Faliure, Type>> call({required Parm parm});
}

class GetPlacesUsecase extends Usecase<AwesomePlacesEntity, ParmSearch> {
  final IGetPlaces repository;

  GetPlacesUsecase({required this.repository});
  @override
  Future<Either<Faliure, AwesomePlacesEntity>> call(
      {required ParmSearch parm}) {
    return repository.call(parm: parm);
  }
}
