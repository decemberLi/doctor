import 'package:doctor/theme/common_style.dart';
import 'package:flutter/material.dart';

class FormItem extends StatelessWidget {
  final Widget child;
  final String label;
  final EdgeInsetsGeometry padding;
  final double height;
  FormItem({
    @required this.child,
    this.label,
    this.padding = const EdgeInsets.all(0),
    this.height,
  });

  Widget _getChild() {
    if (this.label == null) {
      return this.child;
    }
    return Row(
      children: [
        Text(
          this.label,
          style: MyStyles.labelTextStyle,
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: this.child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: this.padding,
      height: this.height,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(0, 90, 160, 0.1),
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: this._getChild(),
    );
  }
}
