import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:equatable/equatable.dart';

abstract class AwesomePlacesSearchEvent extends Equatable {
  final List<AwesomePlacesSearchModel> places;
  const AwesomePlacesSearchEvent({required this.places});
}

class AwesomePlacesSearchLoadingEvent extends AwesomePlacesSearchEvent {
  final String value;
  const AwesomePlacesSearchLoadingEvent(
      {required this.value, required List<AwesomePlacesSearchModel> places})
      : super(places: places);

  @override
  List<Object?> get props => [value, places];
}

class AwesomePlacesSearchClouseEvent extends AwesomePlacesSearchEvent {
  const AwesomePlacesSearchClouseEvent(
      {required List<AwesomePlacesSearchModel> places})
      : super(places: places);

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
