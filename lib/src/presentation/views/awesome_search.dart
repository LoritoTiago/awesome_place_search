import 'dart:async';
import 'dart:developer';

import 'package:awesome_place_search/src/commons/widgets/custom_text_field.dart';
import 'package:awesome_place_search/src/core/const.dart';
import 'package:awesome_place_search/src/core/dependencies/dependencies.dart';
import 'package:awesome_place_search/src/core/services/debouncer.dart';
import 'package:awesome_place_search/src/data/models/prediction_model.dart';
import 'package:awesome_place_search/src/presentation/controller/awesome_place_search_controller.dart';
import 'package:awesome_place_search/src/presentation/controller/search_state.dart';
import 'package:awesome_place_search/src/presentation/views/widgets/awesome_place_search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

///[AwesomePlaceSearch]
/// This is the Main Class
class AwesomePlaceSearch {
  final String key;
  final String hint;
  final String errorText;
  final BuildContext context;
  final Widget? itemWidget;
  final Widget? loadingWidget;
  final InputDecoration? searchTextFieldDecoration;
  final Color? dividerItemColor;
  final double dividerItemWidth;
  final Widget? placeIcon;

  final Widget? onError;
  final Widget? onEmpty;
  final double? elevation;
  final List<String> countries;
  final Color? indicatorColor;
  final TextStyle? subtitleStyle;
  final TextStyle? titleStyle;
  final Function(Future<PredictionModel>) onTap;

  final dependencies = Dependencies();
  AwesomePlaceSearchController? _controller;

  AwesomePlaceSearch({
    required this.context,
    this.searchTextFieldDecoration,
    required this.key,
    this.elevation,
    this.dividerItemWidth = 0.2,
    this.countries = const [],
    this.errorText = "something went wrong",
    this.hint = "where are we going?",
    required this.onTap,
    this.onEmpty,
    this.onError,
    this.itemWidget,
    this.loadingWidget,
    this.dividerItemColor,
    this.placeIcon,
    this.indicatorColor,
    this.subtitleStyle,
    this.titleStyle,
  }) {
    //init clean architecture dependency

    assert(dividerItemWidth < 1.0, "The divider width must be less than 1.0");
    dependencies.initDependencies(key);
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: _bodyModal(height: _height),
            );
          });
        });
      },
    );
  }

// final places = state.places.predictions ?? [];

//       if (state is AwesomePlacesSearchClickedState) {
//         onTap(Future.value(state.place));
//         if (Navigator.canPop(context)) {
//           Navigator.pop(context);
//         }
//       }
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
            const SizedBox(height: 20),
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
                      elevation: elevation,
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
    if (_searchState == SearchState.empty) {
      return Positioned.fill(top: 80, child: _emptyList());
    }

    if (_searchState == SearchState.keyEmpty) {
      return Positioned.fill(
        top: 80,
        child: onEmpty ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.no_encryption_gmailerrorred_outlined,
                  size: 120.0,
                ),
                const SizedBox(height: 20),
                Text(keyEmptyMessage),
              ],
            ),
      );
    }

    if (_searchState == SearchState.serverError) {
      return Positioned.fill(
        top: 80,
        child: onError ??
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

    return Positioned.fill(top: 80, child: _list(places: places));
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
      placeIcon: placeIcon,
      placesTypes: place.types,
      subtitle: place.structuredFormatting!.secondaryText ?? "",
      indicatorColor: indicatorColor,
      subtitleStyle: subtitleStyle,
      titleStyle: titleStyle,
      onTap: () {},
    );
    // return ListTile(
    //   onTap: () {
    //     // bloc.add(
    //     //   AwesomePlacesSearchClickedEvent(
    //     //     places: AwesomePlacesSearchModel(predictions: []),
    //     //     place: place,
    //     //   ),
    //     // );
    //   },
    //   leading: _getIcon(types: place.types!),
    //   title: Text("${place.description}"),
    //   subtitle: Text("${place.structuredFormatting!.secondaryText}"),
    // )
  }

  ///[_getIcon]
  ///Get the current icon of place result item typ
  // Widget _getIcon({required List<String> types}) {
  //   IconData? data;
  //   for (var element in GlobalConst.typeList) {
  //     element.map((key, value) {
  //       if (_controller!.checkIfContains(types, key)) {
  //         data = value;
  //       }
  //       return MapEntry(key, value);
  //     });
  //   }

  //   return Icon(data ?? Icons.location_on_outlined);
  // }

  ///[_emptyList]
  ///If the place list is empty then this widget is displayed
  Widget _emptyList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const SkeletonAvatar(
            style: SkeletonAvatarStyle(
              shape: BoxShape.rectangle,
              width: 50,
              height: 50,
            ),
          ),
          title: SkeletonLine(
            style: SkeletonLineStyle(
              height: 16,
              width: double.infinity,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          subtitle: SkeletonLine(
            style: SkeletonLineStyle(
              height: 16,
              width: 100,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
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
}
