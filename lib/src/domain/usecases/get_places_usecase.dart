part of 'use_case.dart';

class GetPlacesUseCase extends UseCase<AwesomePlacesSearchEntity, ParamSearchEntity> {
  GetPlacesUseCase({required this.repository});
  final IGetSearchRepository repository;

  @override
  Future<Either<Failure, AwesomePlacesSearchEntity>> call(
      {required ParamSearchEntity param}) {
    return repository.getPlace(param: param);
  }
}
