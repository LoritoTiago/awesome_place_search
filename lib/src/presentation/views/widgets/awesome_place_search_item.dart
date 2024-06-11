import 'dart:developer';

import 'package:awesome_place_search/src/commons/consts/const.dart';
import 'package:flutter/material.dart';

class AwesomePlaceSearchItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String>? placesTypes;
  final String searchedValue;
  final double dividerWidth;
  final Color? dividerColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? indicatorColor;

  final Widget? placeIcon;
  // final bool canShowBorder;
  // final bool searched;
  final VoidCallback onTap;
  const AwesomePlaceSearchItem({
    super.key,
    this.searchedValue = "",
    this.placesTypes,
    this.dividerColor,
    required this.dividerWidth,
    // this.searched = false,
    required this.title,
    required this.subtitle,
    this.placeIcon,
    // this.canShowBorder = false,
    required this.onTap,
    this.indicatorColor,
    this.subtitleStyle,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return item();
  }

  bool haveOnList({required String value, required List<String> data}) {
    for (var element in data) {
      log("${element.toLowerCase() == value.toLowerCase()}", name: "Compare");
      if (element.toLowerCase() == value.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  Widget item() {
    List<TextSpan> spans = [];

    String search = searchedValue.toLowerCase();

    final titleSplit = title.toLowerCase().split(",").map((e) => e.trim());

    final subtitleSplit =
        subtitle.toLowerCase().split(",").map((e) => e.trim());

    Set<String> setTitle = Set.from(titleSplit);
    Set<String> setSubtitle = Set.from(subtitleSplit);

    Set<String> difference = setTitle.difference(setSubtitle);

    log("$setTitle ", name: "$setSubtitle");
    String item = List.from(difference).join(", ");

    const weight = FontWeight.w400;
    int start = item.indexOf(search);

    const size = 16.0;

    var titleStyleWithIndicatorColor =
        titleStyle?.copyWith(color: indicatorColor ?? Colors.blue) ??
            const TextStyle(
              color: Colors.blue,
              fontSize: size,
              fontWeight: weight,
            );

    if (start >= 0) {
      spans.add(TextSpan(
        text: item.substring(0, start),
        style: titleStyleWithIndicatorColor,
      ));
      spans.add(TextSpan(
        text: item.substring(start, start + search.length).toUpperCase(),
        style: titleStyleWithIndicatorColor,
      ));
      spans.add(TextSpan(
        text: item.substring(start + search.length).toUpperCase(),
        style: titleStyle ??
            const TextStyle(
                color: Colors.black, fontSize: size, fontWeight: weight),
      ));
    } else {
      spans.add(
        TextSpan(
          text: item.toUpperCase(),
          style: titleStyle ??
              const TextStyle(
                color: Colors.black,
                fontSize: size,
                fontWeight: weight,
              ),
        ),
      );
    }

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: dividerColor ?? Colors.grey,
              width: dividerWidth,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            placeIcon ?? _getIcon(),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: spans,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    // color: ColorsConst.grey.withOpacity(.8),
                    // size: 10,
                    // overflow: TextOverflow.ellipsis,
                    // fontWeight: FontWeight.w400,
                    style: subtitleStyle ??
                        const TextStyle(
                          fontSize: 14.0,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _getIcon() {
  //   return _getIconPlace(types: );
  // }

  Widget _getIcon() {
    final types = placesTypes ?? [];
    IconData? data;
    for (var element in GlobalConst.typeList) {
      element.map((key, value) {
        if (checkIfContains(types, key)) {
          data = value;
        }
        return MapEntry(key, value);
      });
    }

    return Icon(data ?? Icons.location_on_outlined);
  }

  ///[checkIfContains]
  bool checkIfContains(List<String> types, List<String> data) {
    return types
        .where((type) => data.where((current) => type == current).isNotEmpty)
        .isNotEmpty;
  }
}
