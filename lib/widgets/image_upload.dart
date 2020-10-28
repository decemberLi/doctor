import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  final List<OssFileEntity> images;

  final double width;

  final double height;

  final Function onChange;

  /// 自定义上传后的图类别
  final String customUploadImageType;

  ImageUpload({
    this.images = const <OssFileEntity>[],
    this.width = 74,
    this.height = 60,
    this.onChange,
    this.customUploadImageType,
  });

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  List<OssFileEntity> _images;

  final _imagePicker = ImagePicker();

  initialize() {
    _images = widget.images;
  }

  @override
  void initState() {
    this.initialize();
    print('$ImageUpload --- initState');
    super.initState();
  }

  // @override
  // void didUpdateWidget(ImageUpload oldWidget) {
  //   this.initialize();
  //   print('$ImageUpload --- didUpdateWidget');
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  didChangeDependencies() {
    this.initialize();
    print('$ImageUpload --- didChangeDependencies');
    super.didChangeDependencies();
  }

  _pickImage() async {
    int index = await DialogHelper.showBottom(context);
    if (index == null || index == 2) {
      return;
    }
    var source = index == 0 ? ImageSource.camera : ImageSource.gallery;
    return await _imagePicker.getImage(source: source);
  }

  _uploadImage() async {
    try {
      PickedFile image = await _pickImage();
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
      child: Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
          color: ThemeColor.colorLine,
        )),
        child: Icon(
          Icons.add,
          color: ThemeColor.colorLine,
        ),
      ),
      onTap: _uploadImage,
    );
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

  Widget renderImageItem(OssFileEntity image) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          FutureBuilder(
            future: _getImageUrlByOssId(image),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  image.url != null) {
                return Image.network(
                  image.url,
                  width: widget.width,
                  height: widget.height,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitHeight,
                );
              }
              return Container(
                width: widget.width,
                height: widget.height,
              );
            },
          ),
          Positioned(
            top: -12.0,
            right: -12.0,
            child: IconButton(
              padding: EdgeInsets.all(4),
              alignment: Alignment.topRight,
              icon: Icon(
                Icons.remove_circle,
                size: 16.0,
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
          _uploadBtn(),
        ],
      ),
    );
  }
}
