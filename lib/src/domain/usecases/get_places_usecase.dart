part of 'use_case.dart';

class GetPlacesUsecase
    extends Usecase<AwesomePlacesSearchEntity, ParamSearchEntity> {
  final IGetPlacesRepository repository;

  GetPlacesUsecase({required this.repository});
  @override
  Future<Either<Failure, AwesomePlacesSearchEntity>> call(
      {required ParamSearchEntity param}) {
    return repository.call(param: param);
  }
}
