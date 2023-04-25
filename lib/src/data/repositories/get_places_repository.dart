import 'package:awesome_place_search/src/core/error/failures/empty_failure.dart';
import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/core/error/failures/key_empty_failure.dart';
import 'package:awesome_place_search/src/core/error/failures/server_failure.dart';

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
      {required ParamSearchEntity param}) async {
    try {
      final res = await dataSource.call(param: param as ParamSearchModel);
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
