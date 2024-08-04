import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  final bool value;
  final Widget title;
  final Function(bool value) onChanged;
  const CustomSwitchTile(this.title, this.value, this.onChanged, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) => SwitchListTile(
        activeColor: Colors.blue,
        title: title,
        value: value,
        onChanged: onChanged,
      );
}
