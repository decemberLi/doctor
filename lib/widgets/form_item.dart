import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

/// 统一表单项样式
class FormItem extends StatelessWidget {
  final Widget child;
  final String label;
  final String value;
  final EdgeInsetsGeometry padding;
  final double height;
  final FormItemBorderDirection borderDirection;
  FormItem({
    this.child,
    this.label,
    this.value,
    this.padding = const EdgeInsets.all(0),
    this.height,
    this.borderDirection = FormItemBorderDirection.top,
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
          child: this.child ??
              Text(
                value,
                style: MyStyles.inputTextStyle,
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    BorderSide side = BorderSide(
      color: ThemeColor.colorLine,
      style: BorderStyle.solid,
    );
    Border border;
    switch (borderDirection) {
      case FormItemBorderDirection.bottom:
        border = Border(bottom: side);
        break;
      case FormItemBorderDirection.none:
        break;
      default:
        border = Border(top: side);
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: this.padding,
      height: this.height,
      decoration: BoxDecoration(
        border: border,
      ),
      child: this._getChild(),
    );
  }
}

enum FormItemBorderDirection { top, bottom, none }
