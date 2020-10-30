import 'package:doctor/http/common_service.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetail extends StatefulWidget {
  final ResourceModel data;
  final openTimer;
  final closeTimer;
  VideoDetail(this.data, this.openTimer, this.closeTimer);
  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  VideoPlayerController _controller;
  bool _isPlaying = false;
  _initData() async {
    var files = await CommonService.getFile({
      'ossIds': [widget.data.attachmentOssId]
    });
    _controller = VideoPlayerController.network(
      files[0]['tmpUrl'],
    );
    _controller.addListener(() {
      final bool isPlaying = _controller.value.isPlaying;
      if (isPlaying && isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
        //计时器
        print('开');
        widget.openTimer();
      }
      if (!isPlaying && isPlaying != _isPlaying) {
        print('关');
        setState(() {
          _isPlaying = isPlaying;
        });
        widget.closeTimer();
      }
    });
    print(files[0]['tmpUrl']);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this._initData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 渲染视频信息
  Widget _renderVideoInfo() {
    TextStyle boldTextStyle = TextStyle(
      color: ThemeColor.colorFF222222,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );
    TextStyle lightTextStyle = TextStyle(
      color: ThemeColor.primaryGeryColor,
      fontSize: 14.0,
    );
    EdgeInsets commonPadding = EdgeInsets.only(left: 18, right: 18, top: 12);
    return Container(
      color: Colors.white,
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            height: 44.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ThemeColor.colorFFF0EDF1),
              ),
            ),
            child: Text(
              '资料介绍',
              style: TextStyle(
                color: ThemeColor.primaryColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: commonPadding,
            alignment: Alignment.centerLeft,
            child: Text(
              widget.data.title,
              style: boldTextStyle,
            ),
          ),
          Container(
            padding: commonPadding,
            alignment: Alignment.centerLeft,
            child: Text(
              '主讲人：${widget.data.info.presenter}',
              style: lightTextStyle,
            ),
          ),
          Container(
            padding: commonPadding,
            alignment: Alignment.centerLeft,
            child: Text(
              '内容概要',
              style: boldTextStyle,
            ),
          ),
          Container(
            padding: commonPadding,
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              child: Text(
                '\t\t\t${widget.data.info.summary}',
                style: lightTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          AceVideo(controller: _controller),
          Expanded(
            child: _renderVideoInfo(),
          ),
        ],
      ),
    );
  }
}
