import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final double elevation;
  final bool autofocus;
  final Function(String) onChange;
  final InputDecoration? searchTextFieldDecorator;

  const CustomTextField({
    super.key,
    this.autofocus = false,
    required this.elevation,
    this.hint,
    required this.controller,
    required this.onChange,
    this.searchTextFieldDecorator,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: searchTextFieldDecorator != null ? 0.0 : elevation,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.grey.withOpacity(.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: controller,
          onChanged: onChange,
          autofocus: autofocus,
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
