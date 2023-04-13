import 'dart:developer';

import 'package:awesome_place_search/src/presentation/bloc/awesome_places_search_state.dart';

import '../data/data_sources/get_places_remote_datasource.dart';
import '../data/repositories/get_places_repository.dart';
import '../domain/usecases/get_places_usecase.dart';
import 'bloc/awesome_places_search_bloc.dart';
import 'bloc/awesome_places_search_event.dart';
import 'widgets/custom_text_field.dart';

import 'package:flutter/material.dart';

import 'package:skeletons/skeletons.dart';

class AwesomeSearch {
  final BuildContext context;
  final Function onTap;
  AwesomeSearch({required this.context, required this.onTap}) {
    final dataSource = GetPlacesRemoteDataSource();
    final repository = GetPlaceRepository(dataSource: dataSource);
    final usecase = GetPlacesUsecase(repository: repository);
    bloc = AwesomePlacesBloc(usecase: usecase);
    bloc.input.add(const AwesomePlacesSearchInitialEvent());
    show();
  }
  late final AwesomePlacesBloc bloc;

  final txtsearch = TextEditingController();
  double height = 0.0;
  bool searching = true;

  void show() {
    // final size = MediaQuery.of(context).size;
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
    );
  }

  Widget _bodyModal({required double heigth}) {
    return StreamBuilder<AwesomePlacesSearchState>(
        stream: bloc.stream,
        builder: (context, AsyncSnapshot<AwesomePlacesSearchState> state) {
          final res = state.data?.places ?? [];
          log(res.length.toString());
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
                      Positioned.fill(
                        top: 80,
                        child: _emptyList(),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        child: CustomTextField(
                          controller: txtsearch,
                          onChange: (value) {
                            log("$value");
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

  TextStyle _getTextStyle(TextType textType) {
    if (textType == TextType.title) {
      return TextStyle(
        fontSize: 3.0 * height / 100,
        fontWeight: FontWeight.w600,
      );
    }

    if (textType == TextType.subtitle) {
      return const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      );
    }

    return const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
    );
  }
}

enum TextType { title, subtitle, caption }
