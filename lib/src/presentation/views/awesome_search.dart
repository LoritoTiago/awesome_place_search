import 'dart:async';
import 'dart:developer';

import 'package:awesome_place_search/src/commons/widgets/custom_text_field.dart';
import 'package:awesome_place_search/src/core/dependencies/dependencies.dart';
import 'package:awesome_place_search/src/core/services/debouncer.dart';
import 'package:awesome_place_search/src/data/models/prediction_model.dart';
import 'package:awesome_place_search/src/presentation/controller/awesome_place_search_controller.dart';
import 'package:awesome_place_search/src/presentation/controller/search_state.dart';
import 'package:awesome_place_search/src/presentation/views/widgets/awesome_place_search_item.dart';
import 'package:flutter/material.dart';

///[AwesomePlaceSearch]
/// This is the Main Class
class AwesomePlaceSearch {
  final String apiKey;
  final String hint;
  final String errorText;
  final BuildContext context;
  final double modalBorderRadius;

  final Widget? loadingWidget;
  final InputDecoration? searchTextFieldDecoration;
  final Color? dividerItemColor;
  final double dividerItemWidth;
  final Widget? placeIconWidget;

  final Widget? onErrorWidget;

  final double? elevation;
  final List<String> countries;
  final Color? indicatorColor;
  final TextStyle? subtitleStyle;
  final Widget? invalidKeyWidget;

  final TextStyle? titleStyle;
  final Function(Future<PredictionModel>) onTap;

  final dependencies = Dependencies();
  AwesomePlaceSearchController? _controller;

  AwesomePlaceSearch({
    required this.context,
    this.searchTextFieldDecoration,
    required this.apiKey,
    this.modalBorderRadius = 15.0,
    this.elevation,
    this.dividerItemWidth = 0.2,
    this.countries = const [],
    this.errorText = "something went wrong",
    this.hint = "Where are we going?",
    required this.onTap,
    this.invalidKeyWidget,
    this.onErrorWidget,
    this.loadingWidget,
    this.dividerItemColor,
    this.placeIconWidget,
    this.indicatorColor,
    this.subtitleStyle,
    this.titleStyle,
  }) {
    //init clean architecture dependency

    // assert(dividerItemWidth < 1.0, "The divider width must be less than 1.0");

    dependencies.initDependencies(apiKey);
    _controller = AwesomePlaceSearchController(
        dependencies: dependencies, countries: countries);
  }

  // late final AwesomePlacesSearchBloc bloc;

  final _textSearch = TextEditingController();
  final Debounce _debounce = Debounce(milliseconds: 500);
  double _height = 0.0;

  SearchState _searchState = SearchState.none;
  List<PredictionModel> _places = [];

  ///[show]
  ///Show modal to search places
  void show() async {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.grey.withOpacity(.7),
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      builder: (context) {
        return Builder(builder: (context) {
          return LayoutBuilder(builder: (_, BoxConstraints constraints) {
            _height = constraints.maxHeight;
            return Container(
              height: _height * .9,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(modalBorderRadius),
                  topRight: Radius.circular(modalBorderRadius),
                  // topLeft: ,
                  // topRight: Radius.circular(modalBorderRadius),
                ),
              ),
              child: _bodyModal(height: _height),
            );
          });
        });
      },
    );
  }

  ///[_bodyModal]
  ///Component that constitutes the body of the modal
  Widget _bodyModal({required double height}) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // const SizedBox(height: 10),
            Container(
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.3),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  _switchState(_places),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: CustomTextField(
                      hint: hint,
                      searchTextFieldDecorator: searchTextFieldDecoration,
                      elevation: elevation ?? 10.0,
                      controller: _textSearch,
                      onChange: (value) {
                        _debounce(callback: () {
                          if (value.isEmpty) {
                            setState(() => _searchState = SearchState.none);
                            return;
                          }

                          _searchData(state: setState);
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  ///[_switchState]
  ///This component checks what the
  ///current state is and displays
  ///the appropriate widget depending on the state
  Widget _switchState(
    // AwesomePlacesSearchState? state,
    List<PredictionModel> places,
  ) {
    if (_searchState == SearchState.none) {
      return const Positioned(left: 0, top: 0, child: SizedBox.shrink());
    }
    if (_searchState == SearchState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchState == SearchState.invalidKey) {
      return Positioned.fill(
        top: 80,
        child: invalidKeyWidget ??
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.no_encryption_gmailerrorred_outlined,
                  size: 120.0,
                ),
                SizedBox(height: 20),
                Text("Invalid key"),
              ],
            ),
      );
    }

    if (_searchState == SearchState.serverError) {
      return Positioned.fill(
        top: 80,
        child: onErrorWidget ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.nearby_error,
                  size: 120.0,
                ),
                const SizedBox(height: 20),
                Text(errorText),
              ],
            ),
      );
    }

    return Positioned.fill(top: 50, child: _list(places: places));
  }

  ///[_list]
  ///Show all places result
  Widget _list({required List<PredictionModel> places}) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return _item(place: places[index]);
      },
    );
  }

  ///[_item]
  ///Item of place result list
  Widget _item({required PredictionModel place}) {
    log(place.latitude.toString());

    return AwesomePlaceSearchItem(
      title: place.description ?? "",
      searchedValue: _textSearch.text,
      dividerColor: dividerItemColor,
      dividerWidth: dividerItemWidth,
      placeIcon: placeIconWidget,
      placesTypes: place.types,
      subtitle: place.structuredFormatting!.secondaryText ?? "",
      indicatorColor: indicatorColor,
      subtitleStyle: subtitleStyle,
      titleStyle: titleStyle,
      onTap: () {
        _tapItem(place: place);
      },
    );
  }

  void _searchData({required StateSetter state}) async {
    state(() {
      _searchState = SearchState.loading;
    });

    final result = await _controller?.getPlaces(value: _textSearch.text);

    result?.fold((left) {
      state(() {
        _searchState = _controller!.mapError(left);
      });
    }, (right) {
      state(() {
        _places = right.predictions ?? [];
        _searchState = SearchState.success;
      });
    });
  }

  void _tapItem({required PredictionModel place}) async {
    final result = await _controller?.getLatLng(value: place.placeId ?? "");
    result?.fold((left) {
      throw Exception("Was not possible to obtain the coordinates");
    }, (right) {
      place.latitude = right.latModel;
      place.longitude = right.lngModel;
      onTap(Future.value(place));
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }
}
