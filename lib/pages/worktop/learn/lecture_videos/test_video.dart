import 'dart:io';

import 'package:doctor/pages/worktop/learn/lecture_videos/upload_video.dart';
import 'package:doctor/pages/worktop/learn/model/learn_record_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/debounce.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/widgets/video/chewie/chewie.dart';
import 'package:doctor/widgets/video/chewie_ex/custom_controls.dart';
import 'package:doctor/widgets/video/chewie_ex/custom_player_with_controls.dart';
import 'package:doctor/widgets/video/chewie_video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TestVideo extends StatefulWidget {
  @override
  _TestVideoState createState() => _TestVideoState();
}

class _TestVideoState extends State<TestVideo> {
  VideoPlayerController _controller = VideoPlayerController.network(
    'https://oss-dev.e-medclouds.com/Business-attachment/2020-11/105893/11220756-IMG_3191.mp4?Expires=1605185652&OSSAccessKeyId=LTAI4G4YMh1PB4BdD6BpC4qU&Signature=Jm4Ewp7Qs8n9VLcHiBP43etCX1c%3D',
  );

  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    this._initialize();
  }

  @override
  void didUpdateWidget(TestVideo oldWidget) {
    this._initialize();
    super.didUpdateWidget(oldWidget);
  }

  _initialize() async {
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoInitialize: true,
      autoPlay: false,
      showControls: true,
      customControls: CustomControls(),
      placeholder: new Container(
        color: Color.fromRGBO(0, 0, 0, 0.75),
      ),
    );
  }

  Future<void> _selectVideos() async {
    final File file = await ImageHelper.pickSingleVideo(
      context,
      source: 1,
    );
    if (file != null && mounted) {
      _controller = VideoPlayerController.file(file);
      await _controller.setVolume(1.0);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试视频'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 40),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Chewie(
                controller: _chewieController,
                child: CustomPlayerWithControls(),
              ),
              // child: UploadVideoDetail(
              //   LearnRecordingItem(
              //       videoOssId: '20201111D9DD3FB347004F37BF28360BB8B3412D'),
              //   _controller,
              // ),
            ),
            GestureDetector(
              child: Text('重新选择视频',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: ThemeColor.primaryColor,
                  )),
              onTap: debounce(() {
                // 收起键盘
                // FocusScope.of(context).requestFocus(FocusNode());
                _controller?.pause();
                _selectVideos();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
