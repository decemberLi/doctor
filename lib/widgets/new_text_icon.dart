import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

/// 学习计划通用标记图标
class LearnTextIcon extends StatelessWidget {
  final String text;
  final Color color;
  final EdgeInsetsGeometry margin;
  LearnTextIcon({
    this.text = '新',
    this.color = Colors.red,
    this.margin = const EdgeInsets.only(bottom: 10, left: 10),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      margin: this.margin,
      decoration: BoxDecoration(
        color: this.color,
        boxShadow: [
          BoxShadow(
              color: this.color.withOpacity(0.4),
              offset: Offset(0.0, 3.0),
              blurRadius: 4.0)
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomRight: Radius.circular(14)),
      ),
      child: Text(
        this.text,
        style: TextStyle(
            color: ThemeColor.colorFFFFFF,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
