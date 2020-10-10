import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

/// 通用业务按钮
class AceButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final AceButtonType type;
  final double width;
  final double height;
  final Color color;
  final double fontSize;

  AceButton({
    @required this.onPressed,
    @required this.text,
    this.color = ThemeColor.primaryColor,
    this.type = AceButtonType.primary,
    this.width = 310,
    this.height = 44,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    ShapeBorder shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(height / 2)));

    RaisedButton primaryBtn = RaisedButton(
      onPressed: onPressed,
      color: color,
      shape: shape,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
    );
    FlatButton greyBtn = FlatButton(
      onPressed: onPressed,
      color: ThemeColor.colorFFF8F8F8,
      shape: shape,
      child: Text(
        text,
        style: TextStyle(color: ThemeColor.colorFF5F6266, fontSize: fontSize),
      ),
    );

    Widget child = primaryBtn;
    Decoration decoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(height / 2)),
      boxShadow: [
        BoxShadow(
          color: Color(0x66189A8C),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
    );
    if (type == AceButtonType.grey) {
      child = greyBtn;
      decoration = null;
    }

    return Container(
      width: width,
      height: height,
      child: child,
      decoration: decoration,
    );
  }
}

enum AceButtonType { primary, grey }
