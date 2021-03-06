import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
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
                  return PhotoViewGalleryPageOptions.customChild(
                    child: GestureDetector(
                      child: res.type == 0
                          ? Image(image: FileImage(File(res.uri)))
                          : CachedNetworkImage(
                          imageUrl: res.uri,
                          filterQuality: FilterQuality.high,
                          cacheKey: '${res.uri.hashCode}',
                          progressIndicatorBuilder: (
                              BuildContext context,
                              String url,
                              DownloadProgress progress,
                              ) {
                            return GestureDetector(
                              child: Container(
                                color: ThemeColor.colorFFEDEDED,
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {},
                            );
                          },
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error)),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
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
            //??????index??????
            top: MediaQuery.of(context).padding.top + 15,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text("${currentIndex + 1}/${widget.images.length}",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          Positioned(
            //?????????????????????
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
