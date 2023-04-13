import 'package:dartz/dartz.dart';

import '../../domain/entities/awesome_place_entity.dart';
import '../../domain/repositories/i_get_places.dart';
import '../../core/error/exceptions/server_exception.dart';
import '../../core/error/faliures/empty_faliure.dart';
import '../../core/error/faliures/i_faliure.dart';
import '../../core/error/faliures/server_faliure.dart';
import '../data_sources/get_places_remote_datasource.dart';
import '../models/awesome_place_model.dart';

class GetPlaceRepository extends IGetPlacesRepository {
  final GetPlacesRemoteDataSource dataSource;

  GetPlaceRepository({required this.dataSource});
  @override
  Future<Either<Faliure, AwesomePlacesSearchEntity>> call(
      {required ParmSearchEntity parm}) async {
    try {
      final res = await dataSource.call(parm: parm as ParmSearchModel);
      if (res.predictions!.isEmpty) {
        return Left(EmptyFaliure());
      }
      return Right(res);
    } on ServerException {
      return Left(ServerFailure(message: "Server error"));
    } catch (e) {
      return Left(ServerFailure(message: "Something went wrong"));
    }
  }
}
