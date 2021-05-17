import 'dart:io';
import 'dart:typed_data';

import 'package:doctor/pages/user/user_detail/uploadImage.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/permission_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';

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

class FileData {
  File originFile;
  Uint8List thumbData;
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
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      var assetEntity =
          await CameraPicker.pickFromCamera(context,shouldLockPortrait: false);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
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

  /// source: 0 camera， 1 gallery
  static Future<FileData> ehancePickSingleImage(BuildContext context,
      {int source = 0, bool needCompress = true}) async {
    await Future.delayed(Duration(milliseconds: 500));
    var originFile ;
    var thumbData ;
    if (0 == source && await PermissionHelper.checkCameraPermission(context)) {
      var assetEntity = await CameraPicker.pickFromCamera(context);
      originFile = await assetEntity.file;
      thumbData = await assetEntity.thumbData;
    } else if (source == 1 &&
        await PermissionHelper.checkPhotosPermission(context)) {
      var assetEntity = await AssetPicker.pickAssets(context,
          maxAssets: 1, requestType: RequestType.image);
      originFile = await assetEntity.first.file;
      thumbData = await assetEntity.first.thumbData;
    }

    // 压缩
    if (originFile == null) {
      return Future.value(null);
    }

    if (needCompress) {
      return FileData()
      ..thumbData = thumbData
      ..originFile = await _compressImage(originFile);
    }
    return originFile;
  }

  static Future<List<FileData>> pickMultiImageFromGallery(BuildContext context,
      {bool needCompress = true, int max = 9}) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (!await PermissionHelper.checkPhotosPermission(context)) {
      return [];
    }
    var list = await AssetPicker.pickAssets(context,
        maxAssets: max, requestType: RequestType.image);
    if (list == null) {
      return [];
    }
    List<FileData> originFiles = [];
    await EasyLoading.instance.flash(() async {
      try {
        List<Future> fence = [];
        for (var element in list) {
          if (Platform.isAndroid) {
            var data = FileData()
              ..thumbData = await element.thumbData
              ..originFile =
              await element.file; //await compressImage(await element.file);
            originFiles.add(data);
          } else {
            var fileData = FileData();
            originFiles.add(fileData);
            var thumbAction = element.thumbData.then((value){
              fileData.thumbData = value;
            });
            var action = element.file.then((value) async {
              fileData.originFile = value;
            });
            fence.add(thumbAction);
            fence.add(action);
            if (fence.length == 10) {
              await Future.wait(fence);
              await Future.delayed(Duration(milliseconds: 40));
              fence.clear();
            }
          }
        }
        await Future.wait(fence);
      } catch (e) {
        throw '文件不存在';
      }
    });
    return originFiles;
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
