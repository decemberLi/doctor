import 'dart:io';

import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/route/fade_route.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/widgets/photo_view_simple_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ImageUpload extends StatefulWidget {
  final List<OssFileEntity> images;

  final double width;

  final double height;

  final Function onChange;

  /// 自定义上传后的图类别
  final String customUploadImageType;

  final int maxLength;

  ImageUpload({
    this.images = const <OssFileEntity>[],
    this.width = 74,
    this.height = 60,
    this.onChange,
    this.customUploadImageType,
    this.maxLength = 3,
  });

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  List<OssFileEntity> _images;

  initialize() {
    if (_images != widget.images) {
      _images = widget.images;
    }
  }

  @override
  void initState() {
    this.initialize();
    super.initState();
  }

  @override
  void didUpdateWidget(ImageUpload oldWidget) {
    this.initialize();
    super.didUpdateWidget(oldWidget);
  }

  _pickImage() async {
    int index = await DialogHelper.showBottom(context);
    if (index == null || index == 2) {
      return;
    }

    return await ImageHelper.pickSingleImage(context, source: index);
  }

  _uploadImage() async {
    try {
      File image = await _pickImage();
      if (image == null || image.path == null) {
        return;
      }
      OssFileEntity entity = await OssService.upload(image.path);
      if (widget.customUploadImageType != null) {
        entity.type = widget.customUploadImageType;
      }
      setState(() {
        _images.add(entity);
        if (widget.onChange != null) {
          widget.onChange(_images);
        }
      });
    } catch (e) {
      debugPrint(e);
    }
  }

  /// 上传按钮
  Widget _uploadBtn() {
    return GestureDetector(
      child: ImageItemWrapper(
        width: widget.width,
        height: widget.height,
        child: Icon(
          Icons.add,
          color: ThemeColor.colorLine,
        ),
      ),
      onTap: _uploadImage,
    );
  }

  Widget renderImageItem(OssFileEntity image) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none, children: [
          ImageItem(
            image: image,
            width: widget.width,
            height: widget.height,
            customUploadImageType: widget.customUploadImageType,
          ),
          Positioned(
            top: -16.0,
            right: -16.0,
            child: IconButton(
              padding: EdgeInsets.all(4),
              alignment: Alignment.center,
              constraints: BoxConstraints(
                minWidth: 30,
                minHeight: 30,
              ),
              icon: Icon(
                Icons.remove_circle,
                size: 24.0,
                color: Color(0xFFF57575),
              ),
              onPressed: () {
                setState(() {
                  _images.remove(image);
                  if (widget.onChange != null) {
                    widget.onChange(_images);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          ..._images.map((e) => renderImageItem(e)).toList(),
          if (_images.length < widget.maxLength) _uploadBtn(),
        ],
      ),
    );
  }
}

class ImageItemWrapper extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  ImageItemWrapper({
    this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeColor.colorLine,
        ),
      ),
      child: child,
    );
  }
}

class ImageItem extends StatefulWidget {
  /// 自定义上传后的图类别
  final String customUploadImageType;

  final OssFileEntity image;

  final double width;

  final double height;

  ImageItem({
    this.image,
    this.customUploadImageType,
    this.width,
    this.height,
  });

  @override
  _ImageItemState createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  Future<OssFileEntity> _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _getImageUrlByOssId(widget.image);
  }

  Future<OssFileEntity> _getImageUrlByOssId(OssFileEntity image) async {
    if (image.url == null) {
      var data = await OssService.getFile({
        'ossIds': [image.ossId]
      });
      if (data.isNotEmpty) {
        image.url = data[0]['tmpUrl'];
        image.type = widget.customUploadImageType ?? data[0]['type'];
      }
    }
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            widget.image.url != null) {
          ImageProvider imageProvider = NetworkImage(widget.image.url);
          Image imageWidget = Image(
            image: imageProvider,
            width: widget.width,
            height: widget.height,
            alignment: Alignment.topCenter,
            fit: BoxFit.fitHeight,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return ImageItemWrapper(
                width: widget.width,
                height: widget.height,
                child: LinearPercentIndicator(
                  percent: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : 0.0,
                  progressColor: ThemeColor.primaryColor,
                ),
              );
            },
          );
          return GestureDetector(
            child: imageWidget,
            onTap: () {
              Navigator.of(context).push(
                FadeRoute(
                  page: PhotoViewSimpleScreen(
                    imageProvider: imageProvider,
                    heroTag: 'simple',
                  ),
                  // page: PhotoViewGalleryScreen(
                  //   images: this._images.map((e) => e.url).toList(),
                  // ),
                ),
              );
            },
          );
        }
        return ImageItemWrapper(
          width: widget.width,
          height: widget.height,
          child: LinearPercentIndicator(
            percent: 0.0,
            progressColor: ThemeColor.primaryColor,
          ),
        );
      },
    );
  }
}
