import 'package:awesome_place_search/src/core/dependencies/dependencies.dart';
import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:awesome_place_search/src/data/models/lat_lng_model.dart';
import 'package:dartz/dartz.dart';

class AwesomePlaceSearchController {
  final Dependencies dependencies;

  AwesomePlaceSearchController({required this.dependencies});

  Future<Either<Failure, AwesomePlacesSearchModel>> getPlaces(
      {required String value}) async {
    final result = await dependencies.repository?.getPlace(
        param: ParamSearchModel(key: dependencies.key!, value: value));

    return result!;
    // result?.fold((left) {
    //   if (left is KeyEmptyFailure) {
    //     // emit(AwesomePlacesSearchKeyEmptyState(
    //     //     message: "Please enter a valid key"));
    //   }
    //   if (left is ServerFailure) {
    //     // emit(AwesomePlacesSearchErrorState());
    //   }
    // }, (right) {
    //   final res = right as AwesomePlacesSearchModel;
    //   // log(res.predictions!.length.toString());
    //   // add(AwesomePlacesSearchLoadedEvent(places: res));
    // });
  }

  Future<Either<Failure, LatLngModel>> getLatLng(
      {required String value}) async {
    final result = await dependencies.repository?.getLatLng(placeId: value);

    return result!;
  }
}
