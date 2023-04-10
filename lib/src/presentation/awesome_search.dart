import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Awesome_search {
  final BuildContext context;
  final Function onTap;
  Awesome_search({required this.context, required this.onTap});

  void show() {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: size.height * .9,
          width: double.infinity,
        );
      },
    );
  }
}
