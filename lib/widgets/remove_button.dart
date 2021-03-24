import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

class RemoveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  RemoveButton({
    this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, children: [
        Container(
          height: 30,
          child: OutlinedButton(
            child: Text(
              this.text ?? '',
              style: MyStyles.primaryTextStyle_12,
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              side: BorderSide(width: 1, color: ThemeColor.primaryColor),
            ),
            onPressed: onPressed,
          ),
        ),
        Positioned(
          top: -5.0,
          right: -5.0,
          child: Icon(
            Icons.remove_circle,
            size: 16.0,
            color: Color(0xFFF57575),
          ),
        ),
      ],
    );
  }
}
