import "package:flutter/material.dart";

///Reusable [SwitchListTile]
class CustomSwitchTile extends StatelessWidget {
  ///
  const CustomSwitchTile({
    required this.title,
    required this.onChanged,
    required this.value,
    super.key,
  });

  ///The [value] of the switch
  final bool value;

  ///The [title] from the [SwitchListTile]
  final Widget title;

  ///The function when it's changed
  final void Function({required bool value}) onChanged;
  @override
  Widget build(BuildContext context) => SwitchListTile(
        activeThumbColor: Colors.blue,
        title: title,
        value: value,
        onChanged: (x) => onChanged(value: x),
      );
}
