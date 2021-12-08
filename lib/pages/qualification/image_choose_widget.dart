import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnAddImageCallback = void Function();

typedef OnRemoveImageCallback = void Function();

typedef OnShowOriginImageCallback = void Function(String url);

class ImageChooseWidget extends StatelessWidget {
  final Widget cameraWidget;
  final String url;
  final double width;
  final double height;
  final OnAddImageCallback addImgCallback;
  final OnRemoveImageCallback removeImgCallback;
  final OnAddImageCallback showOriginImgCallback;
  final bool enableModified;
  final _dashDecoration = DashedDecoration(
    dashedColor: ThemeColor.primaryColor,
    gap: 3,
    borderRadius: BorderRadius.circular(8),
  );

  ImageChooseWidget({
    hintText,
    double width,
    double height,
    this.url,
    this.addImgCallback,
    this.removeImgCallback,
    this.showOriginImgCallback,
    this.enableModified = true,
  })  : this.width = width ?? double.infinity,
        this.height = height ?? 85,
        this.cameraWidget = GestureDetector(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/camera.png',
                  width: 32,
                  height: 28,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    hintText ?? '上传照片',
                    style:
                        TextStyle(color: ThemeColor.primaryColor, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            if (addImgCallback != null) {
              addImgCallback();
            }
          },
        );

  @override
  Widget build(BuildContext context) {
    _container({Widget child}) {
      return Container(
        width: width > 85 ? width : 85,
        height: height > 85 ? height : 85,
        decoration: _dashDecoration,
        child: child,
      );
    }

    if (url == null || url == '') {
      return GestureDetector(
          child: _container(child: cameraWidget),
          onTap: () {
            if (addImgCallback != null) {
              addImgCallback();
            }
          });
    }

    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            alignment: Alignment.center,
            height: height > 85 ? height : 85,
            width: width ?? double.infinity,
            decoration: _dashDecoration,
            child: GestureDetector(
              child: Image.network(url, fit: BoxFit.fill),
              onTap: () {
                showOriginImgCallback();
              },
            ),
          ),
          if (enableModified)
            Positioned(
              right: -16,
              top: -16,
              child: GestureDetector(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
                  child: Icon(
                    Icons.remove_circle,
                    size: 18.0,
                    color: url == null ? Colors.transparent : Color(0xFFF57575),
                  ),
                ),
                onTap: removeImgCallback,
              ),
            )
        ],
      ),
    );
  }
}
