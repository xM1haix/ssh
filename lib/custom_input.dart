import "package:flutter/material.dart";
import "package:flutter/services.dart";

///Reusable widget for TextFeidls
class CustomInput extends StatelessWidget {
  ///
  const CustomInput(
    this.name,
    this.controller, {
    this.isPort = false,
    this.isHide = false,
    this.hiden,
    super.key,
  });

  /// the [TextEditingController]
  final TextEditingController controller;

  /// The [name] releated the the [TextField]
  final String name;

  ///Checks if the [TextField] is for port to set to numbers
  final bool isPort;

  ///Widget suffix for the [TextField] used only for the [IconButton]
  ///to change the [TextField.obscureText]
  final Widget? hiden;

  ///The [TextField.obscureText]
  final bool isHide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        obscureText: isHide,
        keyboardType: isPort ? TextInputType.number : null,
        inputFormatters:
            isPort ? [FilteringTextInputFormatter.digitsOnly] : null,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: hiden,
          hintText: name,
          labelText: name,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
