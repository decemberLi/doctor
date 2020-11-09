import 'dart:io';

import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

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

class ImageHelper {
  /// source: 0 camera， 1 gallery
  static Future<File> pickSingleImage(BuildContext context, {int source = 0}) async {
    await Future.delayed(Duration(milliseconds: 500));
    var file;
    if (0 == source) {
      var assetEntity = await CameraPicker.pickFromCamera(context);
      return await  assetEntity.file
          .timeout(Duration(seconds: 5), onTimeout: () => null);
    }
    var assetEntity = await AssetPicker.pickAssets(
      context,
      maxAssets: 1,
      requestType: RequestType.image,
    );
    return await assetEntity.first.file
        .timeout(Duration(seconds: 5), onTimeout: () => null);
  }

  /// source: 0 camera， 1 gallery
  static pickSingleVideo(BuildContext context, {int source = 0}) async {
    await Future.delayed(Duration(milliseconds: 500));
    var file;
    if (0 == source) {
      var assetEntity = await CameraPicker.pickFromCamera(context);
      return assetEntity.file
          .timeout(Duration(seconds: 5), onTimeout: () => null);
    }
    var assetEntity = await AssetPicker.pickAssets(
      context,
      maxAssets: 1,
      requestType: RequestType.video,
    );
    return assetEntity.first.file
        .timeout(Duration(seconds: 5), onTimeout: () => null);
  }
}
