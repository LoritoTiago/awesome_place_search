import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/data/data_sources/get_search_remote_datasource.dart';
import 'package:awesome_place_search/src/domain/entities/lat_lng_entity.dart';
import 'package:awesome_place_search/src/domain/entities/param_search_entity.dart';
import '../../core/error/exceptions/key_empty_exception.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/awesome_place_entity.dart';
import '../../domain/repositories/i_get_search_repository.dart';
import '../models/awesome_place_model.dart';

class GetSearchRepository extends IGetSearchRepository {
  GetSearchRepository({required this.dataSource});

  final GetSearchRemoteDataSource dataSource;

  @override
  Future<Either<Failure, LatLngEntity>> getLatLng({required String placeId}) async {
    try {
      final res = await dataSource.getLatLng(param: placeId);
      return Right(res);
    } catch (e) {
      return Left(ServerFailure(message: "Something went wrong"));
    }
  }
  @override
  Future<Either<Failure, AwesomePlacesSearchEntity>> getPlace({required ParamSearchEntity param}) async {
    try {
      final res = await dataSource.getPlace(param: param as ParamSearchModel);
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
