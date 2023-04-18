import 'package:awesome_place_search/src/core/error/faliures/i_faliure.dart';
import 'package:awesome_place_search/src/core/error/faliures/server_faliure.dart';
import 'package:awesome_place_search/src/data/data_sources/get_lat_lng_data_source.dart';
import 'package:awesome_place_search/src/domain/entities/lat_lng_entity.dart';
import 'package:awesome_place_search/src/domain/repositories/i_get_places.dart';
import 'package:dartz/dartz.dart';

class GetLatLngRepository implements IGetLatLngRepository {
  final GetLatLngDataSource dataSource;

  GetLatLngRepository({required this.dataSource});

  @override
  Future<Either<Faliure, LatLngEntity>> call({required String placeId}) async {
    try {
      final res = await dataSource.call(parm: placeId);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: "Something went wrong"));
    }
  }
}
