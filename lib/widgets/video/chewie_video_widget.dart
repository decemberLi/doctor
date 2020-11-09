import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'chewie/src/chewie_player.dart';
import 'chewie_ex/custom_controls.dart';
import 'chewie_ex/custom_player_with_controls.dart';

class ChewieVideoWidget extends StatefulWidget {
  final VideoPlayerController controller;
  ChewieVideoWidget({
    @required this.controller,
  });
  @override
  _ChewieVideoWidgetState createState() => _ChewieVideoWidgetState();
}

class _ChewieVideoWidgetState extends State<ChewieVideoWidget> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  void pauseVideo() {
    _chewieController?.pause();
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController = null;
    _videoPlayerController = null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _videoPlayerController = widget.controller;
    }
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: false,
      showControls: true,
      customControls: CustomControls(),
      placeholder: new Container(
        color: Colors.black,
      ),
    );
  }

  @override
  void dispose() {
    _chewieController?.pause();
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
      child: CustomPlayerWithControls(),
    );
  }
}
