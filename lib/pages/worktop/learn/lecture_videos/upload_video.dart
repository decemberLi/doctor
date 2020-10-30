import 'package:doctor/http/common_service.dart';
import 'package:doctor/pages/worktop/learn/model/learn_record_model.dart';
import 'package:doctor/widgets/ace_video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UploadVideoDetail extends StatefulWidget {
  final LearnRecordingItem data;
  final VideoPlayerController tocontroller;
  UploadVideoDetail(this.data, this.tocontroller);
  @override
  _UploadVideoDetailState createState() => _UploadVideoDetailState();
}

class _UploadVideoDetailState extends State<UploadVideoDetail> {
  VideoPlayerController _controller;
  bool _isPlaying = false;
  _initData() async {
    if (widget.tocontroller != null) {
      _controller = widget.tocontroller;
    } else {
      var files = await CommonService.getFile({
        'ossIds': [widget.data.videoOssId]
      });
      _controller = VideoPlayerController.network(
        files[0]['tmpUrl'],
      );
    }

    print(widget.tocontroller);
    _controller.addListener(() {
      final bool isPlaying = _controller.value.isPlaying;
      if (isPlaying && isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
      if (!isPlaying && isPlaying != _isPlaying) {
        print('关');
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    });
    print('tmpUrl==> $_controller');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this._initData();
  }

  @override
  void didUpdateWidget(covariant UploadVideoDetail oldWidget) {
    this._initData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AceVideo(controller: _controller);
  }
}
