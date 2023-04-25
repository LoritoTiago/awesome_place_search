part of 'awesome_places_search_bloc.dart';

///[AwesomePlacesSearchState]
abstract class AwesomePlacesSearchState extends Equatable {
  final AwesomePlacesSearchModel places;

  const AwesomePlacesSearchState({required this.places});
}

///[AwesomePlacesSearchInitialState]
class AwesomePlacesSearchInitialState extends AwesomePlacesSearchState {
  AwesomePlacesSearchInitialState() : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [];
}

///[AwesomePlacesSearchErrorState]
///this state is issued when some error occurred
class AwesomePlacesSearchErrorState extends AwesomePlacesSearchState {
  AwesomePlacesSearchErrorState() : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [];
}

///[AwesomePlacesSearchKeyEmptyState]
///This status is issued when the seat list is empty
class AwesomePlacesSearchKeyEmptyState extends AwesomePlacesSearchState {
  final String message;

  AwesomePlacesSearchKeyEmptyState({required this.message})
      : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [];
}

///[AwesomePlacesSearchLoadingState]
///This status is issued when you are searching for places
class AwesomePlacesSearchLoadingState extends AwesomePlacesSearchState {
  final String value;

  AwesomePlacesSearchLoadingState({required this.value})
      : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [value];
}

///[AwesomePlacesSearchLoadedState]
///This status is issued when you finish searching for places
class AwesomePlacesSearchLoadedState extends AwesomePlacesSearchState {
  const AwesomePlacesSearchLoadedState({required super.places});

  @override
  List<Object?> get props => [places];
}

///[AwesomePlacesSearchClickedState]
///This state is emitted when clicking on an item
class AwesomePlacesSearchClickedState extends AwesomePlacesSearchState {
  final PredictionModel place;

  const AwesomePlacesSearchClickedState({
    required this.place,
    required super.places,
  });

  @override
  List<Object?> get props => [places, place];
}
