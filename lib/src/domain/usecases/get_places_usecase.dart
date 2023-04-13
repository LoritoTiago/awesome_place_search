import '../entities/awesome_place_entity.dart';
import '../repositories/i_get_places.dart';
import '../../error/faliures/i_faliure.dart';
import 'package:dartz/dartz.dart';

abstract class Usecase<Type, Parm> {
  Future<Either<Faliure, Type>> call({required Parm parm});
}

class GetPlacesUsecase extends Usecase<AwesomePlacesEntity, ParmSearchEntity> {
  final IGetPlacesRepository repository;

  GetPlacesUsecase({required this.repository});
  @override
  Future<Either<Faliure, AwesomePlacesEntity>> call(
      {required ParmSearchEntity parm}) {
    return repository.call(parm: parm);
  }
}
