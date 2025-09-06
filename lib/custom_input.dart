import "package:flutter/material.dart";
import "package:flutter/services.dart";

class CustomInput extends StatelessWidget {
  const CustomInput(
    this.name,
    this.controller, {
    this.isPort = false,
    this.isHide = false,
    this.hiden,
    super.key,
  });
  final TextEditingController controller;
  final String name;
  final bool isPort;
  final Widget? hiden;
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
