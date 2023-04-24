import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';

import '../../core/error/exceptions/key_empty_exception.dart';

import 'package:dartz/dartz.dart';

import '../../domain/entities/awesome_place_entity.dart';
import '../../domain/repositories/i_get_places.dart';

import '../data_sources/get_places_remote_datasource.dart';
import '../models/awesome_place_model.dart';

class GetPlaceRepository extends IGetPlacesRepository {
  final GetPlacesRemoteDataSource dataSource;

  GetPlaceRepository({required this.dataSource});
  @override
  Future<Either<Failure, AwesomePlacesSearchEntity>> call(
      {required ParmSearchEntity parm}) async {
    try {
      final res = await dataSource.call(parm: parm as ParmSearchModel);
      if (res.predictions!.isEmpty) {
        return Left(EmptyFailure());
      }
      return Right(res);
    } on KeyEmptyException {
      return Left(KeyEmptyFailure());
    } catch (e) {
      return Left(ServerFailure(message: "Something went wrong"));
    }
  }
}
