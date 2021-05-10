import 'dart:io';

import 'package:doctor/pages/user/user_detail/uploadImage.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/permission_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
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
  static Map<String, CompressFormat> _suffixMap = {
    'jpg': CompressFormat.jpeg,
    'png': CompressFormat.png,
    'heic': CompressFormat.heic,
    'webp': CompressFormat.webp
  };

  static Future<File> cropImage(BuildContext context, String path) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropImageRoute(File(path)),
      ),
    );
  }

  /// source: 0 camera， 1 gallery
  static Future<File> pickSingleImage(BuildContext context,
      {int source = 0, bool needCompress = true}) async {
    await Future.delayed(Duration(milliseconds: 500));
    var originFile;
    if (0 == source && await PermissionHelper.checkCameraPermission(context)) {
      var assetEntity = await CameraPicker.pickFromCamera(context);
      originFile = await assetEntity.file;
    } else if (source == 1 &&
        await PermissionHelper.checkPhotosPermission(context)) {
      var assetEntity = await AssetPicker.pickAssets(context,
          maxAssets: 1, requestType: RequestType.image);
      originFile = await assetEntity.first.file;
    }

    // 压缩
    if (originFile == null) {
      return Future.value(null);
    }

    if (needCompress) {
      return await _compressImage(originFile);
    }
    return originFile;
  }

  static Future<List<File>> pickMultiImageFromGallery(BuildContext context,
      {bool needCompress = true, int max = 9}) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (await PermissionHelper.checkPhotosPermission(context)) {
      var list = await AssetPicker.pickAssets(context,
          maxAssets: max, requestType: RequestType.image);
      if (list != null) {
        List<File> originFiles = [];
        for (var element in list) {
          originFiles.add(await compressImage(await element.file));
        }
        return originFiles;
      }
    }

    return [];
  }

  /// source: 0 camera， 1 gallery
  static pickSingleVideo(BuildContext context, {int source = 0}) async {
    await Future.delayed(Duration(milliseconds: 500));
    var file;
    if (0 == source && await PermissionHelper.checkCameraPermission(context)) {
      var assetEntity = await CameraPicker.pickFromCamera(context);
      file = assetEntity?.file
          ?.timeout(Duration(seconds: 5), onTimeout: () => null);
    } else if (source == 1 &&
        await PermissionHelper.checkCameraPermission(context)) {
      var assetEntity = await AssetPicker.pickAssets(
        context,
        maxAssets: 1,
        requestType: RequestType.video,
      );
      file = assetEntity?.first?.file
          ?.timeout(Duration(seconds: 5), onTimeout: () => null);
    }

    return file;
  }

  static Future<File> _compressImage(File originFile) async {
    var directory = Directory(originFile.path);
    var baseName = basename(originFile.path);
    var targetPath = join(directory.parent.path, 'compressed_$baseName');

    print('origin file path ${originFile.path}');
    print('compressed target file path ${originFile.path}');

    var compressedImageFile = await FlutterImageCompress.compressAndGetFile(
        originFile.path, targetPath,
        format: _compressFormat(originFile.path));

    print('compressed image file path is --> ${compressedImageFile?.path}');
    return compressedImageFile;
  }

  static Future<File> compressImage(File originFile) async {
    return _compressImage(originFile);
  }

  static _compressFormat(String path) {
    for (var each in _suffixMap.keys) {
      if (path.endsWith(each)) {
        return _suffixMap[each];
      }
    }

    throw Error.safeToString('Can not support file type, fil is $path');
  }
}
