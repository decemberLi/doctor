import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageResources {
  // 0 is  local path, 1 is network resource
  int type;
  String uri;

  ImageResources(this.type, this.uri);
}

class EnhancePhotoViewer extends StatefulWidget {
  final List<ImageResources> images;
  final int index;
  final String heroTag;
  PageController controller;

  EnhancePhotoViewer({
    Key key,
    @required this.images,
    this.index = 0,
    this.controller,
    this.heroTag = 'PhotoViewGalleryScreen',
  }) : super(key: key) {
    controller =
        controller == null ? PageController(initialPage: index) : controller;
  }

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<EnhancePhotoViewer> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  var res = widget.images[index];
                  return PhotoViewGalleryPageOptions(
                    imageProvider: res.type == 0
                        ? FileImage(File(res.uri))
                        : CachedNetworkImageProvider(res.uri,
                            errorListener: () {
                            return (context, url, error) => Icon(Icons.error);
                          }),
                    heroAttributes: widget.heroTag.isNotEmpty
                        ? PhotoViewHeroAttributes(tag: widget.heroTag)
                        : null,
                    onTapDown: (  BuildContext context,
                        TapDownDetails details,
                        PhotoViewControllerValue controllerValue,){
                      Navigator.pop(context);
                    }
                  );
                },
                itemCount: widget.images.length,
                // loadingBuilder: ,
                backgroundDecoration: null,
                pageController: widget.controller,
                enableRotation: true,
                onPageChanged: (index) {
                  setState(
                    () {
                      currentIndex = index;
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            //图片index显示
            top: MediaQuery.of(context).padding.top + 15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text("${currentIndex + 1}/${widget.images.length}",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          Positioned(
            //右上角关闭按钮
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
