import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DialogHelper {

  static showBottom(BuildContext context) async {
    var item = ['拍照', '从手机相册选择', '取消'];
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: item.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(item[index]),
                onTap: () => Navigator.pop(context, index));
          },
        );
      },
    );
  }

}
