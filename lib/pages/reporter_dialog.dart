import 'package:flutter/cupertino.dart';

void showWeekReporter(BuildContext ctx) {
  showCupertinoDialog<bool>(context: ctx, builder: (context) {
    return CupertinoAlertDialog(
      content: Container(
      ),
    );
  });
}
