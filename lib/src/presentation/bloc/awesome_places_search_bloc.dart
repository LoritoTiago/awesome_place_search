import 'dart:async';
import 'dart:developer';

import 'package:awesome_place_search/src/core/error/faliures/server_faliure.dart';
import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:awesome_place_search/src/data/models/prediction_model.dart';
import 'package:equatable/equatable.dart';
import 'package:awesome_place_search/src/domain/usecases/use_case.dart';

part 'awesome_places_search_state.dart';
part 'awesome_places_search_event.dart';

class AwesomePlacesBloc {
  final GetPlacesUsecase usecase;
  final GetLatLngUsecase latLngUsecase;
  final String key;

  final StreamController<AwesomePlacesSearchEvent> _input =
      StreamController<AwesomePlacesSearchEvent>();

  final StreamController<AwesomePlacesSearchState> _output =
      StreamController<AwesomePlacesSearchState>();

  Sink<AwesomePlacesSearchEvent> get input => _input.sink;

  Stream<AwesomePlacesSearchState> get stream => _output.stream;

  AwesomePlacesBloc(
      {required this.usecase, required this.latLngUsecase, required this.key}) {
    _input.stream.listen(_listenEvent);
  }

  void _listenEvent(AwesomePlacesSearchEvent event) async {
    if (event is AwesomePlacesSearchLoadingEvent) {
      _output.add(AwesomePlacesSearchLoadingState(value: event.value));
      _searchPlaces(event);
    }

    if (event is AwesomePlacesSearchLoadedEvent) {
      _output.add(AwesomePlacesSearchLoadedState(places: event.places));
    }

    if (event is AwesomePlacesSearchClickedEvent) {
      final usecase = await latLngUsecase.call(parm: event.place.placeId!);
      usecase.fold((left) {
        if (left is ServerFailure) {
          _output.add(
            AwesomePlacesSearchErrorState(message: "Algo correu mal"),
          );
        }
      }, (rigth) {
        event.place.latitude = rigth.lat;
        event.place.longitude = rigth.lng;
        _output.add(
          AwesomePlacesSearchClickedState(
              place: event.place, places: event.places),
        );
      });
    }

    if (event is AwesomePlacesSearchClouseEvent) {
      log("Dismissed");
      _input.close();
    }
  }

  void _searchPlaces(AwesomePlacesSearchLoadingEvent event) async {
    final parm = ParmSearchModel(value: event.value, key: key);
    final result = await usecase.call(parm: parm);
    result.fold((left) {
      if (left is ServerFailure) {
        _output.add(
          AwesomePlacesSearchErrorState(message: "Algo correu mal"),
        );
      }
    }, (right) {
      final res = right as AwesomePlacesSearchModel;
      log(res.predictions!.length.toString());
      _input.add(AwesomePlacesSearchLoadedEvent(places: res));
    });
  }

  bool checkIfContains(List<String> types, List<String> data) {
    bool res = false;
    for (var type in types) {
      for (var current in data) {
        if (type == current) return true;
      }
    }
    return res;
  }
}
