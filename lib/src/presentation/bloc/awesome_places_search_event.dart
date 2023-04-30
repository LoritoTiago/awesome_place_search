part of 'awesome_places_search_bloc.dart';

///[AwesomePlacesSearchEvent]
abstract class AwesomePlacesSearchEvent extends Equatable {
  final AwesomePlacesSearchModel places;

  const AwesomePlacesSearchEvent({required this.places});
}

///[AwesomePlacesSearchLoadingEvent]
///This event is to let you know that you are looking for places
class AwesomePlacesSearchLoadingEvent extends AwesomePlacesSearchEvent {
  final String value;
  const AwesomePlacesSearchLoadingEvent(
      {required this.value, required AwesomePlacesSearchModel places})
      : super(places: places);

  @override
  List<Object?> get props => [value, places];
}

///[AwesomePlacesSearchLoadedEvent]
///This event is to let you know that I have completed the search for places
class AwesomePlacesSearchLoadedEvent extends AwesomePlacesSearchEvent {
  const AwesomePlacesSearchLoadedEvent(
      {required AwesomePlacesSearchModel places})
      : super(places: places);

  @override
  List<Object?> get props => [places];
}

///[AwesomePlacesSearchClickedEvent]
///this event is to check if user a item of place
class AwesomePlacesSearchClickedEvent extends AwesomePlacesSearchEvent {
  final PredictionModel place;
  const AwesomePlacesSearchClickedEvent(
      {required this.place, required AwesomePlacesSearchModel places})
      : super(places: places);

  @override
  List<Object?> get props => [places, place];
}
