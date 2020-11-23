import 'package:doctor/theme/common_style.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

/// 开处方页面Card
class PrescripionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget trailing;
  final EdgeInsetsGeometry padding;
  final Color color;
  final TextStyle titleStyle;
  final BoxConstraints constraints;

  PrescripionCard({
    this.title,
    this.children = const <Widget>[],
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(30, 0, 30, 10),
    this.color = Colors.white,
    this.titleStyle,
    this.constraints = const BoxConstraints(minHeight: 46),
  });

  @override
  Widget build(BuildContext context) {
    Widget titleText = Text(
      this.title,
      style: this.titleStyle ??
          MyStyles.primaryTextStyle.copyWith(fontWeight: FontWeight.w500),
    );
    Widget titleWidget = Container(
      color: this.color,
      constraints: constraints,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [titleText, this.trailing ?? Container()],
      ),
    );
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      child: Container(
        alignment: Alignment.center,
        padding: this.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget,
            ...this.children,
          ],
        ),
      ),
    );
  }
}
