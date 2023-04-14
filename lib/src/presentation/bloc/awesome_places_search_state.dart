part of 'awesome_places_search_bloc.dart';

///[MainContract]
abstract class AwesomePlacesSearchState extends Equatable {
  final AwesomePlacesSearchModel places;
  const AwesomePlacesSearchState({required this.places});
}

///[Initial]
class AwesomePlacesSearchInitialState extends AwesomePlacesSearchState {
  AwesomePlacesSearchInitialState() : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [];
}

///[Error]
///this state is issued when some error occurred
class AwesomePlacesSearchErrorState extends AwesomePlacesSearchState {
  AwesomePlacesSearchErrorState() : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [];
}

///[Empty]
///This status is issued when the seat list is empty
class AwesomePlacesSearchKeyEmptyState extends AwesomePlacesSearchState {
  final String message;
  AwesomePlacesSearchKeyEmptyState({required this.message})
      : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [];
}

///[Loading]
///This status is issued when you are searching for places
class AwesomePlacesSearchLoadingState extends AwesomePlacesSearchState {
  final String value;
  AwesomePlacesSearchLoadingState({required this.value})
      : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [value];
}

///[Loaded]
///This status is issued when you finish searching for places
class AwesomePlacesSearchLoadedState extends AwesomePlacesSearchState {
  const AwesomePlacesSearchLoadedState(
      {required AwesomePlacesSearchModel places})
      : super(places: places);

  @override
  List<Object?> get props => [places];
}

///[Click]
///This state is emitted when clicking on an item
class AwesomePlacesSearchClickedState extends AwesomePlacesSearchState {
  final PredictionModel place;
  const AwesomePlacesSearchClickedState(
      {required this.place, required AwesomePlacesSearchModel places})
      : super(places: places);

  @override
  List<Object?> get props => [places, place];
}
