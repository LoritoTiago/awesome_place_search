import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:equatable/equatable.dart';

abstract class AwesomePlacesSearchEvent extends Equatable {
  final List<AwesomePlacesSearchModel> places;
  const AwesomePlacesSearchEvent({required this.places});
}

class AwesomePlacesSearchInitialEvent extends AwesomePlacesSearchEvent {
  const AwesomePlacesSearchInitialEvent() : super(places: const []);

  @override
  List<Object?> get props => [];
}

class AwesomePlacesSearchLoadingEvent extends AwesomePlacesSearchEvent {
  const AwesomePlacesSearchLoadingEvent() : super(places: const []);

  @override
  List<Object?> get props => [];
}

class AwesomePlacesSearchLoadedEvent extends AwesomePlacesSearchEvent {
  const AwesomePlacesSearchLoadedEvent(
      {required List<AwesomePlacesSearchModel> places})
      : super(places: places);

  @override
  List<Object?> get props => [places];
}

class AwesomePlacesSearchClickedEvent extends AwesomePlacesSearchEvent {
  final AwesomePlacesSearchModel place;
  const AwesomePlacesSearchClickedEvent(
      {required this.place, required List<AwesomePlacesSearchModel> places})
      : super(places: places);

  @override
  List<Object?> get props => [places, place];
}
