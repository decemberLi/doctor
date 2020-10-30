import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 项目通用视频播放
class AceVideo extends StatefulWidget {
  final VideoPlayerController controller;

  AceVideo({
    @required this.controller,
  });
  @override
  _AceVideoState createState() => _AceVideoState();
}

class _AceVideoState extends State<AceVideo> {
  VideoPlayerController _controller;

  _initialize() {
    if (_controller == null && widget.controller != null) {
      _controller = widget.controller;
    }
  }

  @override
  initState() {
    this._initialize();
    super.initState();
  }

  @override
  void didUpdateWidget(AceVideo oldWidget) {
    this._initialize();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator() {
    return Container(
      alignment: Alignment.center,
      height: 240,
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return _buildIndicator();
    }
    return Chewie(
      controller: ChewieController(
        videoPlayerController: _controller,
        aspectRatio: 3 / 2,
        autoPlay: false,
        autoInitialize: true,
      ),
    );
  }
}
