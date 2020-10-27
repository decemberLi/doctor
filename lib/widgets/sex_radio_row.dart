import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/Radio_row.dart';
import 'package:flutter/material.dart';

class SexRadioRow extends StatefulWidget {
  final int groupValue;
  final ValueChanged<int> onChanged;

  SexRadioRow({
    @required this.groupValue,
    @required this.onChanged,
  });

  @override
  _SexRadioRowState createState() => _SexRadioRowState();
}

class _SexRadioRowState extends State<SexRadioRow> {
  int groupValue;

  @override
  void initState() {
    groupValue = widget.groupValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RadioRow<int>(
          title: Text(
            '男',
            style: MyStyles.inputTextStyle,
          ),
          value: 1,
          groupValue: groupValue,
          onChanged: (int value) {
            setState(() {
              groupValue = value;
              widget.onChanged(value);
            });
          },
        ),
        RadioRow(
          title: Text(
            '女',
            style: MyStyles.inputTextStyle,
          ),
          value: 0,
          groupValue: groupValue,
          onChanged: (int value) {
            setState(() {
              groupValue = value;
              widget.onChanged(value);
            });
          },
        ),
      ],
    );
  }
}
