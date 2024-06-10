import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/data/data_sources/get_search_remote_datasource.dart';
import 'package:awesome_place_search/src/data/models/lat_lng_model.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/exceptions/key_empty_exception.dart';
import '../models/awesome_place_model.dart';

abstract class IRepository {
  Future<Either<Failure, LatLngModel>> getLatLng({required String placeId});

  Future<Either<Failure, AwesomePlacesSearchModel>> getPlace(
      {required ParamSearchModel param});
}

class GetSearchRepository implements IRepository {
  GetSearchRepository({required this.dataSource});

  final GetSearchRemoteDataSource dataSource;

  @override
  Future<Either<Failure, LatLngModel>> getLatLng(
      {required String placeId}) async {
    try {
      final res = await dataSource.getLatLng(param: placeId);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, AwesomePlacesSearchModel>> getPlace(
      {required ParamSearchModel param}) async {
    try {
      final res = await dataSource.getPlace(param: param);
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
