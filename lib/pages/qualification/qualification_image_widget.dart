import 'package:doctor/model/face_photo.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnAddImageCallback = void Function();

typedef OnRemoveImageCallback = void Function();

typedef OnShowOriginImageCallback = void Function(FacePhoto photo);

class ImageSelectWidget extends StatelessWidget {
  final FacePhoto photo;
  final OnAddImageCallback onAddImage;
  final OnRemoveImageCallback onRemoveTap;
  final OnShowOriginImageCallback onShowOriginpic;
  final bool showDecoration;
  final String hint;
  final double width;
  final double height;

  final _dashDecoration = DashedDecoration(
    dashedColor: ThemeColor.primaryColor,
    gap: 3,
    borderRadius: BorderRadius.circular(8),
  );

  ImageSelectWidget({
    hint,
    this.photo,
    this.onAddImage,
    this.onRemoveTap,
    this.onShowOriginpic,
    width,
    height,
    showDecoration,
  })  : showDecoration = showDecoration ?? true,
        hint = hint ?? '上传照片',
        width = width ?? 85,
        height = height ?? 85;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        GestureDetector(
          child: Container(
            alignment: Alignment.center,
            decoration: _dashDecoration,
            child: _doLoadImage(photo),
          ),
          onTap: () {
            // Add or show origin pic
            if (photo == null || photo.url == null || photo.url == '') {
              if (onAddImage != null) {
                onAddImage();
              }
              return;
            }

            if (onShowOriginpic != null) {
              onShowOriginpic(photo);
            }
          },
        ),
        Positioned(
          right: -6,
          top: -6,
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Icon(
                Icons.remove_circle,
                size: 18.0,
                color: photo == null ? Colors.transparent : Color(0xFFF57575),
              ),
            ),
            onTap: () {
              if (onRemoveTap != null) {
                // delete button
                onRemoveTap();
              }
            },
          ),
        )
      ],
    );
  }

  _doLoadImage(FacePhoto photo, {double aspectRatio = 1 / 1}) {
    Widget icon;
    Widget hintWidget = Container(
        margin: EdgeInsets.only(top: 6),
        child: Text(hint,
            style: TextStyle(color: ThemeColor.colorFF8FC1FE, fontSize: 12)));
    icon = Image.asset('assets/images/camera.png', width: 32, height: 28);
    if (photo != null && photo.url != null) {
      icon = ConstrainedBox(
          child: Image.network(photo.url, fit: BoxFit.cover),
          constraints: BoxConstraints.expand());
      hintWidget = Container();
    }

    return Container(
      width: this.width,
      height: this.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [icon, hintWidget],
      ),
    );
  }
}
