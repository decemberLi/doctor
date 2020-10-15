import 'package:chewie/chewie.dart';
import 'package:doctor/http/common_service.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetail extends StatefulWidget {
  final ResourceModel data;
  VideoDetail(this.data);
  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  _initData() async {
    var files = await CommonService.getFile({
      'ossIds': [widget.data.attachmentOssId]
    });
    _controller = VideoPlayerController.network(
      files[0]['tmpUrl'],
    );
    _initializeVideoPlayerFuture = _controller.initialize();
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

  /// 渲染视频区域
  Widget _renderVideo() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Chewie(
            controller: ChewieController(
              videoPlayerController: _controller,
              aspectRatio: 3 / 2,
              autoPlay: false,
              autoInitialize: false,
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            height: 240,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  /// 渲染视频信息
  Widget _renderVideoInfo() {
    TextStyle boldTextStyle = TextStyle(
      color: ThemeColor.colorFF222222,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );
    TextStyle lightTextStyle = TextStyle(
      color: ThemeColor.colorFF666666,
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
          _renderVideo(),
          Expanded(
            child: _renderVideoInfo(),
          ),
        ],
      ),
    );
  }
}
