import "package:flutter/material.dart";

class CustomSwitchTile extends StatelessWidget {
  const CustomSwitchTile(this.title, this.value, this.onChanged, {super.key});
  final bool value;
  final Widget title;
  final Function(bool v) onChanged;
  @override
  Widget build(BuildContext context) => SwitchListTile(
        activeThumbColor: Colors.blue,
        title: title,
        value: value,
        onChanged: onChanged,
      );
}
