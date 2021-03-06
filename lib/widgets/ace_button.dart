import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/debounce.dart';
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
  final Color shadowColor;

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
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    ShapeBorder shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(height / 2)));

    RaisedButton primaryBtn = RaisedButton(
      onPressed: debounce(onPressed),
      color: color ?? ThemeColor.primaryColor,
      shape: shape,
      disabledColor: ThemeColor.primaryColor.withOpacity(0.5),
      child: child ??
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize,
            ),
          ),
    );
    TextButton greyBtn = TextButton(
        onPressed: debounce(onPressed),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(height / 2)),
              color: color ?? ThemeColor.colorFFBCBCBC,),
            child: child ??
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: fontSize,
                  ),
                ),
        )
    );

    FlatButton secondaryBtn = FlatButton(
      onPressed: debounce(onPressed),
      color: color ?? ThemeColor.primaryColor.withOpacity(0.4),
      shape: shape,
      child: child ??
          Text(
            text,
            textAlign: TextAlign.center,
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
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? ThemeColor.primaryColor,
              fontSize: fontSize,
            ),
          ),
      style: OutlinedButton.styleFrom(
        shape: shape,
        side: BorderSide(width: 1, color: color ?? ThemeColor.primaryColor),
      ),
      onPressed: debounce(onPressed),
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
              color: this.shadowColor ?? Color(0x66005AA0),
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
