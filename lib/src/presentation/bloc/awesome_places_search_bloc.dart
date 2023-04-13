import 'dart:async';
import 'dart:developer';

import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:awesome_place_search/src/data/repositories/get_places_repository.dart';
import 'package:awesome_place_search/src/domain/usecases/get_places_usecase.dart';
import 'package:awesome_place_search/src/presentation/bloc/awesome_places_search_event.dart';
import 'package:awesome_place_search/src/presentation/bloc/awesome_places_search_state.dart';

class AwesomePlacesBloc {
  final GetPlacesUsecase usecase;
  final String key;

  final StreamController<AwesomePlacesSearchEvent> _input =
      StreamController<AwesomePlacesSearchEvent>();

  final StreamController<AwesomePlacesSearchState> _output =
      StreamController<AwesomePlacesSearchState>();

  Sink<AwesomePlacesSearchEvent> get input => _input.sink;

  Stream<AwesomePlacesSearchState> get stream => _output.stream;

  AwesomePlacesBloc({required this.usecase, required this.key}) {
    _input.stream.listen(_listenEvent);
  }

  void _listenEvent(AwesomePlacesSearchEvent event) {
    if (event is AwesomePlacesSearchLoadingEvent) {
      _output.add(AwesomePlacesSearchLoadingState(value: event.value));
      _searchPlaces(event);
    }

    if (event is AwesomePlacesSearchLoadedEvent) {}

    if (event is AwesomePlacesSearchClickedEvent) {
      _output.add(
        AwesomePlacesSearchClickedState(
            place: event.place, places: event.places),
      );
    }

    if (event is AwesomePlacesSearchClouseEvent) {
      log("Dismissed");
      _input.close();
    }
  }

  void _searchPlaces(AwesomePlacesSearchLoadingEvent event) async {
    final parm = ParmSearchModel(value: event.value, key: key);
    final result = await usecase.call(parm: parm);
    result.fold((left) {}, (right) {
      final res = right as AwesomePlacesSearchModel;
      log(res.predictions!.length.toString());
      _output.add(AwesomePlacesSearchLoadedState(places: res));
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
