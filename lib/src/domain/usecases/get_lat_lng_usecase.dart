part of 'use_case.dart';

class GetLatLngUseCase extends UseCase<LatLngEntity, String> {
  GetLatLngUseCase({required this.repository});
  final IGetSearchRepository repository;

  @override
  Future<Either<Failure, LatLngEntity>> call({required String param}) async {
    return repository.getLatLng(placeId: param);
  }
}
