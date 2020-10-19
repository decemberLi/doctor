import 'package:flutter/material.dart';

/// 单行文本，超出显示省略号
///
class OneLineText extends StatelessWidget {
  final String text;
  final TextStyle style;

  OneLineText(this.text, {this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: this.style,
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
