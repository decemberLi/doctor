import 'package:flutter/material.dart';

class RadioRow<T> extends StatelessWidget {
  const RadioRow({
    Key key,
    @required this.value,
    @required this.groupValue,
    @required this.onChanged,
    this.toggleable = false,
    this.activeColor,
    this.title,
    this.autofocus = false,
  })  : assert(toggleable != null),
        assert(autofocus != null),
        super(key: key);

  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final bool toggleable;
  final Color activeColor;
  final bool autofocus;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final Widget control = Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      toggleable: toggleable,
      activeColor: activeColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      autofocus: autofocus,
    );
    return Row(
      children: [control, title],
    );
  }
}
