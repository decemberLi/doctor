import 'package:doctor/theme/common_style.dart';
import 'package:doctor/widgets/form_item.dart';
import 'package:doctor/widgets/one_line_text.dart';
import 'package:flutter/material.dart';

/// 药品项
class MedicationItem extends StatefulWidget {
  final int index;

  final Function onDelete;

  MedicationItem({
    Key key,
    this.index,
    this.onDelete,
  });

  @override
  _MedicationItemState createState() => _MedicationItemState();
}

class _MedicationItemState extends State<MedicationItem> {
  int num = 3;

  @override
  Widget build(BuildContext context) {
    return FormItem(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      height: 95.0,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OneLineText(
                  '复方-酮酸片 开同',
                  style: MyStyles.inputTextStyle_12,
                ),
                OneLineText(
                  '规格： 0.62g*10片',
                  style: MyStyles.labelTextStyle_12,
                ),
                OneLineText(
                  '用法用量：每日一次；5片/次；口服',
                  style: MyStyles.inputTextStyle_12,
                ),
              ],
            ),
          ),
          Container(
            width: 90.0,
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print(32343);
                      },
                      child: Text(
                        '编辑',
                        style: MyStyles.primaryTextStyle_12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // print(654654);
                        widget.onDelete(widget.index);
                      },
                      child: Text(
                        '删除',
                        style: MyStyles.primaryTextStyle_12,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      iconSize: 20.0,
                      constraints: BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (num > 1) {
                          setState(() {
                            num -= 1;
                          });
                        }
                      },
                    ),
                    Text(
                      '$num',
                      style: MyStyles.primaryTextStyle_12,
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle),
                      iconSize: 20.0,
                      constraints: BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          num += 1;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
