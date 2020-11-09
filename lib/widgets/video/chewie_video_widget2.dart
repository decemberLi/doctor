import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'chewie2/src/chewie_player.dart';
import 'chewie_ex/custom_controls.dart';
import 'chewie_ex/custom_player_with_controls.dart';

// final GlobalKey<_ChewieVideoWidget2State> videoWidgetKey =
//     new GlobalKey<_ChewieVideoWidget2State>();

class ChewieVideoWidget2 extends StatefulWidget {
  // String playUrl;
  // ChewieVideoWidget2(this.playUrl);
  final VideoPlayerController controller;

  ChewieVideoWidget2({
    @required this.controller,
  });
  // ChewieVideoWidget2(this.controller);

  @override
  _ChewieVideoWidget2State createState() => _ChewieVideoWidget2State();
}

class _ChewieVideoWidget2State extends State<ChewieVideoWidget2> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  void pauseVideo() {
    _chewieController?.pause();
    _chewieController?.dispose();
    _controller?.dispose();
    // _videoPlayerController?.dispose();
    _chewieController = null;
    _controller = null;
    // _videoPlayerController = null;
  }

  @override
  void initState() {
    super.initState();
    // _videoPlayerController = VideoPlayerController.network(widget.playUrl);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
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
    _controller?.dispose();
    // _videoPlayerController?.dispose();
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
