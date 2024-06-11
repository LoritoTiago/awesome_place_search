import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final double? elevation;
  final Function(String) onChange;
  final InputDecoration? searchTextFieldDecorator;

  const CustomTextField({
    super.key,
    this.elevation,
    required this.hint,
    required this.controller,
    required this.onChange,
    this.searchTextFieldDecorator,
  });

  @override
  Widget build(BuildContext context) {
    final elevationData = elevation ?? 5;
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: elevationData,
            offset: Offset(
              0.0,
              elevationData,
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          onChanged: onChange,
          decoration: searchTextFieldDecorator ??
              InputDecoration(
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          controller.text = "";
                        },
                      )
                    : null,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                hintText: hint,
              ),
        ),
      ),
    );
  }
}
