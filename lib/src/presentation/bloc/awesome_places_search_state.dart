import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:equatable/equatable.dart';

abstract class AwesomePlacesSearchState extends Equatable {
  final List<AwesomePlacesSearchModel> places;
  const AwesomePlacesSearchState({required this.places});
}

class AwesomePlacesSearchInitialState extends AwesomePlacesSearchState {
  const AwesomePlacesSearchInitialState() : super(places: const []);

  @override
  List<Object?> get props => [];
}

class AwesomePlacesSearchLoadingState extends AwesomePlacesSearchState {
  const AwesomePlacesSearchLoadingState() : super(places: const []);

  @override
  List<Object?> get props => [];
}

class AwesomePlacesSearchSearchingState extends AwesomePlacesSearchState {
  final String value;
  const AwesomePlacesSearchSearchingState(
      {required this.value, required List<AwesomePlacesSearchModel> places})
      : super(places: places);

  @override
  List<Object?> get props => [places, value];
}

class AwesomePlacesSearchLoadedState extends AwesomePlacesSearchState {
  const AwesomePlacesSearchLoadedState(
      {required List<AwesomePlacesSearchModel> places})
      : super(places: places);

  @override
  List<Object?> get props => [places];
}

class AwesomePlacesSearchClickedState extends AwesomePlacesSearchState {
  final AwesomePlacesSearchModel place;
  const AwesomePlacesSearchClickedState(
      {required this.place, required List<AwesomePlacesSearchModel> places})
      : super(places: places);

  @override
  List<Object?> get props => [places, place];
}
