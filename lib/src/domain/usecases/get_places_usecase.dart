part of 'use_case.dart';

class GetPlacesUsecase
    extends Usecase<AwesomePlacesSearchEntity, ParmSearchEntity> {
  final IGetPlacesRepository repository;

  GetPlacesUsecase({required this.repository});
  @override
  Future<Either<Failure, AwesomePlacesSearchEntity>> call(
      {required ParmSearchEntity parm}) {
    return repository.call(parm: parm);
  }
}
