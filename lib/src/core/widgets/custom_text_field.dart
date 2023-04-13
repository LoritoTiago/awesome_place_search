import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChange;
  const CustomTextField(
      {super.key, required this.controller, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 10,
            offset: const Offset(
              0.0,
              5.0,
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          onChanged: onChange,
          decoration: InputDecoration(
            suffixIcon: controller.text.isNotEmpty
                ? const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  )
                : null,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            border: InputBorder.none,
            hintText: "Ola mundo",
          ),
        ),
      ),
    );
  }
}
