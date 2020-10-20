import 'package:doctor/theme/common_style.dart';
import 'package:flutter/material.dart';

/// 开处方页面Card
class PrescripionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget trailing;
  final EdgeInsetsGeometry padding;
  PrescripionCard({
    this.title,
    this.children,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(30, 0, 30, 10),
  });
  @override
  Widget build(BuildContext context) {
    Widget titleText = Text(
      this.title,
      style: MyStyles.primaryTextStyle.copyWith(fontWeight: FontWeight.w500),
    );
    // Widget titleWidget = ListTile(
    //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
    //   title: Text(
    //     this.title,
    //     style: MyStyles.primaryTextStyle.copyWith(fontWeight: FontWeight.w500),
    //   ),
    //   trailing: this.trailing,
    // );
    Widget titleWidget = Container(
      constraints: BoxConstraints(minHeight: 46),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [titleText, this.trailing ?? Container()],
      ),
    );
    List<Widget> _children = this.children ?? <Widget>[];
    _children.insert(0, titleWidget);
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      child: Container(
        alignment: Alignment.center,
        padding: this.padding,
        child: Column(
          children: _children,
        ),
      ),
    );
  }
}
