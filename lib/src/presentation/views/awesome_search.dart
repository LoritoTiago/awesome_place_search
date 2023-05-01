import 'dart:developer';
import 'package:awesome_place_search/src/commons/consts/const.dart';
import 'package:awesome_place_search/src/commons/widgets/custom_text_field.dart';
import 'package:awesome_place_search/src/core/dependencies/dependencies.dart';
import 'package:awesome_place_search/src/core/services/debouncer.dart';
import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:awesome_place_search/src/data/models/prediction_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/awesome_places_search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

///[AwesomePlaceSearch]
/// This is the Main Class
class AwesomePlaceSearch {
  final String key;
  final String hint;
  final String errorText;
  final BuildContext context;

  final Widget? onError;
  final Widget? onEmpty;
  final Function(Future<PredictionModel>) onTap;
  final dependencies = Dependencies();

  AwesomePlaceSearch({
    required this.context,
    required this.key,
    this.errorText = "something went wrong",
    this.hint = "where are we going?",
    required this.onTap,
    this.onEmpty,
    this.onError,
  }) {
    //init clean architecture dependency
    dependencies.initDependencies(key);
    bloc = dependencies.bloc;
  }

  late final AwesomePlacesSearchBloc bloc;

  final txtsearch = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  double height = 0.0;

  ///[show]
  ///Show modal to search places
  void show() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.grey.withOpacity(.7),
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      builder: (context) {
        return Builder(builder: (context) {
          return LayoutBuilder(builder: (_, BoxConstraints constraints) {
            height = constraints.maxHeight;
            return Container(
              height: height * .9,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: _bodyModal(height: height),
            );
          });
        });
      },
    );
  }

  ///[_bodyModal]
  ///Component that constitutes the body of the modal
  Widget _bodyModal({required double height}) {
    return BlocProvider(
      create: (_) {
        bloc.add(AwesomePlacesSearchLoadingEvent(
          places: AwesomePlacesSearchModel(),
          value: "",
        ));
        return bloc;
      },
      child: BlocBuilder<AwesomePlacesSearchBloc, AwesomePlacesSearchState>(
          builder: (context, state) {
        final places = state.places.predictionsModel ?? [];

        if (state is AwesomePlacesSearchClickedState) {
          onTap(Future.value(state.place));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 100,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.3),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  children: [
                    _switchState(state, places),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: CustomTextField(
                        hint: hint,
                        controller: txtsearch,
                        onChange: (value) {
                          _debouncer(callback: () {
                            bloc.add(
                              AwesomePlacesSearchLoadingEvent(
                                value: value,
                                places: AwesomePlacesSearchModel(),
                              ),
                            );
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
      }),
    );
  }

  ///[_switchState]
  ///This component checks what the
  ///current state is and displays
  ///the appropriate widget depending on the state
  Widget _switchState(
    AwesomePlacesSearchState? state,
    List<PredictionModel> places,
  ) {
    if (state is AwesomePlacesSearchLoadingState) {
      return Positioned.fill(top: 80, child: _emptyList());
    }

    if (state is AwesomePlacesSearchKeyEmptyState) {
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
                Text(state.message),
              ],
            ),
      );
    }

    if (state is AwesomePlacesSearchErrorState) {
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
    return ListTile(
      onTap: () {
        bloc.add(
          AwesomePlacesSearchClickedEvent(
            places: AwesomePlacesSearchModel(predictionsModel: []),
            place: place,
          ),
        );
      },
      leading: _getIcon(types: place.types!),
      title: Text("${place.description}"),
      subtitle: Text("${place.structuredFormatting!.secondaryText}"),
    );
  }

  ///[_getIcon]
  ///Get the current icon of place result item typ
  Widget _getIcon({required List<String> types}) {
    IconData? data;
    for (var element in GlobalConst.typeList) {
      element.map((key, value) {
        if (bloc.checkIfContains(types, key)) {
          data = value;
        }
        return MapEntry(key, value);
      });
    }

    return Icon(data ?? Icons.location_on_outlined);
  }

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
}
