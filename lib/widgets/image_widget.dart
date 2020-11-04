import 'package:flutter/cupertino.dart';

class ImageWidget extends StatefulWidget {
  ImageWidget(
      {@required this.url,
      this.width,
      this.height,
      this.fit,
      this.defImagePath = "assets/images/avatar.png"});

  final String url;
  final double width;
  final double height;
  final String defImagePath;
  final BoxFit fit;

  @override
  State<StatefulWidget> createState() {
    return _StateImageWidget();
  }
}

class _StateImageWidget extends State<ImageWidget> {
  Image _image;

  @override
  void initState() {
    super.initState();
    _image = Image.network(
      widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
    var resolve = _image.image.resolve(ImageConfiguration.empty);
    resolve.addListener(ImageStreamListener((_, __) {
      //加载成功
    }, onError: (dynamic exception, StackTrace stackTrace) {
      //加载失败
      setState(() {
        _image = Image.asset(
          widget.defImagePath,
          width: widget.width,
          height: widget.height,
        );
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return _image;
  }
}
