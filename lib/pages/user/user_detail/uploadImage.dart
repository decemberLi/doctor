import 'dart:io';

import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

/// 裁剪的宽高做成可配置功能 @yetian
class CropImageRoute extends StatefulWidget {
  final File image; //原始图片路径

  CropImageRoute(this.image);

  @override
  _CropImageRouteState createState() => new _CropImageRouteState();
}

class _CropImageRouteState extends State<CropImageRoute> {
  double baseLeft; //图片左上角的x坐标
  double baseTop; //图片左上角的y坐标
  double imageWidth; //图片宽度，缩放后会变化
  double imageScale = 1; //图片缩放比例
  Image imageView;
  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColor.colorFF000000,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 400,
              child: Crop.file(
                widget.image,
                key: cropKey,
                aspectRatio: 1.0,
                alwaysShowGrid: true,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.white),
                    ),
                    // color: Colors.white,
                  ),
                  TextButton(
                    onPressed: () {
                      _doCrop(widget.image);
                    },
                    child: Text(
                      '确认',
                      style: TextStyle(color: Colors.white),
                    ),
                    // color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _doCrop(File originalFile) async {
    final crop = cropKey.currentState;
    final area = crop.area;
    if (area == null) {
      //裁剪结果为空
      print('裁剪不成功');
    }
    bool hasPermissions = await ImageCrop.requestPermissions();
    if (hasPermissions) {
      File cropedFile =
          await ImageCrop.cropImage(file: originalFile, area: crop.area);
      Navigator.pop(context, cropedFile);
      return;
    }

    print('request permissions failed, return original image file.');
    Navigator.pop(context, originalFile);
  }
}
