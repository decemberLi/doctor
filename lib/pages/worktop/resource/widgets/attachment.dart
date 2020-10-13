import 'package:doctor/theme/myIcons.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';

class Attacement extends StatelessWidget {
  final String name;
  Attacement(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Icon(
            MyIcons.icon_article,
            size: 80,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            name,
            style: TextStyle(
              color: ThemeColor.colorFF444444,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          AceButton(
            onPressed: () {
              print(111);
            },
            text: '在线阅读',
          ),
        ],
      ),
    );
  }
}
