import 'dart:developer';

import 'package:awesome_place_search/src/core/consts/const.dart';
import 'package:awesome_place_search/src/data/data_sources/get_lat_lng_data_source.dart';
import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:awesome_place_search/src/data/models/prediction_model.dart';
import 'package:awesome_place_search/src/data/repositories/get_lat_lng_repository.dart';
import 'package:awesome_place_search/src/domain/usecases/use_case.dart';

import '../../data/data_sources/get_places_remote_datasource.dart';
import '../../data/repositories/get_places_repository.dart';

import '../bloc/awesome_places_search_bloc.dart';

import '../../core/widgets/custom_text_field.dart';

import 'package:flutter/material.dart';

import 'package:skeletons/skeletons.dart';

class AwesomeSearch {
  final String key;
  final String hint;
  final String errorText;
  final BuildContext context;
  final Function(Future<PredictionModel>) onTap;

  AwesomeSearch(
      {required this.context,
      required this.key,
      this.errorText = "something went wrong",
      this.hint = "where are we going?",
      required this.onTap}) {
    //init clean architecture dependency
    final dataSource = GetPlacesRemoteDataSource(key: key);
    final repository = GetPlaceRepository(dataSource: dataSource);
    final usecase = GetPlacesUsecase(repository: repository);

    final latLngDataSource = GetLatLngDataSource(key: key);
    final latLngRepository = GetLatLngRepository(dataSource: latLngDataSource);
    final latLngUsecase = GetLatLngUsecase(repository: latLngRepository);
    bloc = AwesomePlacesBloc(
        usecase: usecase, latLngUsecase: latLngUsecase, key: key);
    bloc.input.add(AwesomePlacesSearchLoadingEvent(
        places: AwesomePlacesSearchModel(), value: ""));
    show();
  }
  late final AwesomePlacesBloc bloc;

  final txtsearch = TextEditingController();
  double height = 0.0;

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
              child: _bodyModal(heigth: height),
            );
          });
        });
      },
    ).whenComplete(
      () => bloc.input.add(
        AwesomePlacesSearchClouseEvent(places: AwesomePlacesSearchModel()),
      ),
    );
  }

  Widget _bodyModal({required double heigth}) {
    return StreamBuilder<AwesomePlacesSearchState>(
        stream: bloc.stream,
        builder: (context, AsyncSnapshot<AwesomePlacesSearchState> value) {
          final state = value.data;
          final places = state?.places.predictions ?? [];

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
                            bloc.input.add(
                              AwesomePlacesSearchLoadingEvent(
                                value: value,
                                places: AwesomePlacesSearchModel(),
                              ),
                            );
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

  Widget _switchState(
      AwesomePlacesSearchState? state, List<PredictionModel> places) {
    if (state is AwesomePlacesSearchLoadingState) {
      return Positioned.fill(top: 80, child: _emptyList());
    }

    if (state is AwesomePlacesSearchErrorState) {
      return Positioned.fill(
        top: 80,
        child: Column(
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

  Widget _list({required List<PredictionModel> places}) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return _item(place: places[index]);
      },
    );
  }

  Widget _item({required PredictionModel place}) {
    log(place.latitude.toString());
    return ListTile(
      onTap: () {
        bloc.input.add(
          AwesomePlacesSearchClickedEvent(
            places: AwesomePlacesSearchModel(predictions: []),
            place: place,
          ),
        );
      },
      leading: _getIcon(types: place.types!),
      title: Text("${place.description}"),
      subtitle: Text("${place.structuredFormatting!.secondaryText}"),
    );
  }

  Widget _getIcon({required List<String> types}) {
    if (bloc.checkIfContains(types, GlobalConst.shopingList)) {
      return const Icon(Icons.shopping_bag_outlined);
    }

    if (bloc.checkIfContains(types, GlobalConst.bankList)) {
      return const Icon(Icons.attach_money);
    }

    if (bloc.checkIfContains(types, GlobalConst.healthList)) {
      return const Icon(Icons.health_and_safety_outlined);
    }

    if (bloc.checkIfContains(types, GlobalConst.foofList)) {
      return const Icon(Icons.food_bank_outlined);
    }

    if (bloc.checkIfContains(types, GlobalConst.airportList)) {
      return const Icon(Icons.connecting_airports_outlined);
    }

    if (bloc.checkIfContains(types, GlobalConst.artGalleryList)) {
      return const Icon(Icons.photo_camera_back_outlined);
    }

    if (bloc.checkIfContains(types, GlobalConst.bikeList)) {
      return const Icon(Icons.pedal_bike);
    }

    if (bloc.checkIfContains(types, GlobalConst.stationList)) {
      return const Icon(Icons.directions_bus_filled_sharp);
    }

    return const Icon(Icons.location_on_outlined);
  }

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
