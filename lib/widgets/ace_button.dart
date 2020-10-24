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
  final Color textColor;
  final double fontSize;
  final Widget child;

  AceButton({
    @required this.onPressed,
    this.text,
    this.color,
    this.textColor,
    this.type = AceButtonType.primary,
    this.width = 310,
    this.height = 44,
    this.fontSize = 16,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    ShapeBorder shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(height / 2)));

    RaisedButton primaryBtn = RaisedButton(
      onPressed: onPressed,
      color: color,
      shape: shape,
      child: child ??
          Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize,
            ),
          ),
    );
    FlatButton greyBtn = FlatButton(
      onPressed: onPressed,
      color: color ?? ThemeColor.colorFFBCBCBC,
      shape: shape,
      child: child ??
          Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize,
            ),
          ),
    );

    FlatButton secondaryBtn = FlatButton(
      onPressed: onPressed,
      color: ThemeColor.primaryColor.withOpacity(0.4),
      shape: shape,
      child: child ??
          Text(
            text,
            style: TextStyle(
              color: textColor ?? ThemeColor.primaryColor,
              fontSize: fontSize,
            ),
          ),
    );

    OutlinedButton outlineBtn = OutlinedButton(
      child: child ??
          Text(
            text,
            style: TextStyle(
              color: textColor ?? ThemeColor.primaryColor,
              fontSize: fontSize,
            ),
          ),
      style: OutlinedButton.styleFrom(
        shape: shape,
        side: BorderSide(width: 1, color: color ?? ThemeColor.primaryColor),
      ),
      onPressed: onPressed,
    );

    Widget btn;
    Decoration decoration;
    switch (type) {
      case AceButtonType.primary:
        btn = primaryBtn;
        decoration = BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(height / 2)),
          boxShadow: [
            BoxShadow(
              color: Color(0x663AA7FF),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        );
        break;
      case AceButtonType.secondary:
        btn = secondaryBtn;
        break;
      case AceButtonType.grey:
        btn = greyBtn;
        break;
      case AceButtonType.outline:
        btn = outlineBtn;
        break;
      default:
        btn = primaryBtn;
    }

    return Container(
      width: width,
      height: height,
      child: btn,
      decoration: decoration,
    );
  }
}

enum AceButtonType { primary, secondary, grey, outline }
