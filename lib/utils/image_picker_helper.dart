import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class DialogHelper {
  static showBottom(BuildContext context) async {
    var item = ['拍摄', '从手机相册选择', '取消'];
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      )),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: ThemeColor.secondaryGeryColor,
            );
          },
          shrinkWrap: true,
          itemCount: item.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Center(
                child: Text(
                  item[index],
                  style: TextStyle(
                    fontSize: 14,
                    color: index == item.length - 1
                        ? ThemeColor.colorFF999999
                        : ThemeColor.colorFF444444,
                  ),
                ),
              ),
              onTap: () => Navigator.pop(context, index),
            );
          },
        );
      },
    );
  }
}
