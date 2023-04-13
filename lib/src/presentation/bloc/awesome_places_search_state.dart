import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:equatable/equatable.dart';

abstract class AwesomePlacesSearchState extends Equatable {
  final AwesomePlacesSearchModel places;
  const AwesomePlacesSearchState({required this.places});
}

class AwesomePlacesSearchInitialState extends AwesomePlacesSearchState {
  AwesomePlacesSearchInitialState() : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [];
}

class AwesomePlacesSearchLoadingState extends AwesomePlacesSearchState {
  final String value;
  AwesomePlacesSearchLoadingState({required this.value})
      : super(places: AwesomePlacesSearchModel());

  @override
  List<Object?> get props => [value];
}

class AwesomePlacesSearchSearchingState extends AwesomePlacesSearchState {
  final String value;
  const AwesomePlacesSearchSearchingState(
      {required this.value, required AwesomePlacesSearchModel places})
      : super(places: places);

  @override
  List<Object?> get props => [places, value];
}

class AwesomePlacesSearchLoadedState extends AwesomePlacesSearchState {
  const AwesomePlacesSearchLoadedState(
      {required AwesomePlacesSearchModel places})
      : super(places: places);

  @override
  List<Object?> get props => [places];
}

class AwesomePlacesSearchClickedState extends AwesomePlacesSearchState {
  final PredictionModel place;
  const AwesomePlacesSearchClickedState(
      {required this.place, required AwesomePlacesSearchModel places})
      : super(places: places);

  @override
  List<Object?> get props => [places, place];
}
