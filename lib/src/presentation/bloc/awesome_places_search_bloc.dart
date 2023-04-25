import 'dart:async';
import 'dart:developer';

import 'package:awesome_place_search/src/core/error/failures/key_empty_failure.dart';
import 'package:awesome_place_search/src/core/error/failures/server_failure.dart';
import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:awesome_place_search/src/data/models/prediction_model.dart';
import 'package:equatable/equatable.dart';
import 'package:awesome_place_search/src/domain/usecases/use_case.dart';

part 'awesome_places_search_state.dart';
part 'awesome_places_search_event.dart';

///[Bloc]
///
class AwesomePlacesSearchBloc {
  final GetPlacesUsecase usecase;
  final GetLatLngUsecase latLngUsecase;
  final String key;

  ///[Event]
  ///This is to emit a event inside of bloc
  final StreamController<AwesomePlacesSearchEvent> _input =
      StreamController<AwesomePlacesSearchEvent>();

  ///[State]
  ///This is to emit a state  inside of bloc
  final StreamController<AwesomePlacesSearchState> _output =
      StreamController<AwesomePlacesSearchState>();

  ///[Event]
  ///This is to emit a event outside bloc
  Sink<AwesomePlacesSearchEvent> get input => _input.sink;

  ///[State]
  ///This is to emit a state outside bloc
  Stream<AwesomePlacesSearchState> get stream => _output.stream;

  AwesomePlacesSearchBloc(
      {required this.usecase, required this.latLngUsecase, required this.key}) {
    _input.stream.listen(_listenEvent);
  }

  ///[ListenEvents]
  ///Listen to all triggered events
  void _listenEvent(AwesomePlacesSearchEvent event) async {
    if (event is AwesomePlacesSearchLoadingEvent) {
      _output.add(AwesomePlacesSearchLoadingState(value: event.value));
      _searchPlaces(event);
    }

    if (event is AwesomePlacesSearchLoadedEvent) {
      _output.add(AwesomePlacesSearchLoadedState(places: event.places));
    }

    if (event is AwesomePlacesSearchClickedEvent) {
      final usecase = await latLngUsecase.call(param: event.place.placeId!);
      usecase.fold((left) {
        if (left is ServerFailure) {
          _output.add(
            AwesomePlacesSearchErrorState(),
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

    if (event is AwesomePlacesSearchCloseEvent) {
      log("Dismissed");
      _input.close();
    }
  }

  ///[Search]
  ///Search places when triggered Loading event
  void _searchPlaces(AwesomePlacesSearchLoadingEvent event) async {
    final param = ParamSearchModel(value: event.value, key: key);
    final result = await usecase.call(param: param);
    result.fold((left) {
      if (left is KeyEmptyFailure) {
        _output.add(AwesomePlacesSearchKeyEmptyState(
            message: "Please enter a valid key"));
      }
      if (left is ServerFailure) {
        _output.add(
          AwesomePlacesSearchErrorState(),
        );
      }
    }, (right) {
      final res = right as AwesomePlacesSearchModel;
      log(res.predictions!.length.toString());
      _input.add(AwesomePlacesSearchLoadedEvent(places: res));
    });
  }

  ///[TypeCheck]
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
