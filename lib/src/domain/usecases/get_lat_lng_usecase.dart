part of 'use_case.dart';

class GetLatLngUsecase extends Usecase<LatLngEntity, String> {
  final IGetLatLngRepository repository;

  GetLatLngUsecase({required this.repository});
  @override
  Future<Either<Failure, LatLngEntity>> call({required String parm}) async {
    return repository.call(placeId: parm);
  }
}
