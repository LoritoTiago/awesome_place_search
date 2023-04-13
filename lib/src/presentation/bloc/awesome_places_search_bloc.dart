import 'dart:async';

import 'package:awesome_place_search/src/data/repositories/get_places_repository.dart';
import 'package:awesome_place_search/src/domain/usecases/get_places_usecase.dart';
import 'package:awesome_place_search/src/presentation/bloc/awesome_places_search_event.dart';
import 'package:awesome_place_search/src/presentation/bloc/awesome_places_search_state.dart';

class AwesomePlacesBloc {
  final GetPlacesUsecase usecase;

  final StreamController<AwesomePlacesSearchEvent> _input =
      StreamController<AwesomePlacesSearchEvent>();

  final StreamController<AwesomePlacesSearchState> _output =
      StreamController<AwesomePlacesSearchState>();

  Sink<AwesomePlacesSearchEvent> get input => _input.sink;

  Stream<AwesomePlacesSearchState> get stream => _output.stream;

  AwesomePlacesBloc({required this.usecase}) {
    _input.stream.listen(_listenEvent);
  }

  void _listenEvent(AwesomePlacesSearchEvent event) {
    if (event is AwesomePlacesSearchInitialEvent) {
      _output.add(const AwesomePlacesSearchInitialState());
    }

    if (event is AwesomePlacesSearchLoadingEvent) {}

    if (event is AwesomePlacesSearchLoadedEvent) {}

    if (event is AwesomePlacesSearchClickedEvent) {
      _input.close();
    }
  }
}
