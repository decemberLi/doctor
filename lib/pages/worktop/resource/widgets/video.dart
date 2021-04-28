import 'package:dio/dio.dart';
import 'package:doctor/http/common_service.dart';
import 'package:doctor/http/server.dart';
import 'package:doctor/pages/worktop/resource/model/resource_model.dart';
import 'package:doctor/theme/theme.dart';
// import 'package:doctor/widgets/ace_video.dart';
import 'package:doctor/widgets/video/chewie_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/manager.dart';
import 'package:video_player/video_player.dart';

class VideoDetail extends StatefulWidget {
  final ResourceModel data;
  final openTimer;
  final closeTimer;
  final meetingStartTime;
  final meetingEndTime;
  final taskDetailId;
  final learnPlanId;
  VideoDetail(this.data, this.openTimer, this.closeTimer, this.meetingStartTime,
      this.meetingEndTime, this.taskDetailId, this.learnPlanId);
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
      if (isPlaying) {
        _isPlaying = isPlaying;
        //计时器
        widget.openTimer();
      }
      if (!isPlaying && isPlaying != _isPlaying) {
        _isPlaying = isPlaying;
        widget.closeTimer();
      }
    });
    //签到时间为空 且当前时间在会议时间内
    if (widget.meetingEndTime != null &&
        widget.meetingStartTime != null &&
        widget.learnPlanId != null &&
        widget.data.resourceType == 'VIDEO' &&
        widget.data.meetingSignInTime == null) {
      num start = widget.meetingStartTime;
      num end = widget.meetingEndTime;
      num nowDate = DateTime.now().millisecondsSinceEpoch;
      if (start < nowDate && nowDate < end) {
        showDialog<void>(context: context, builder: (context) => dialog());
      }
    }
    setState(() {});
  }

//签到框
  SimpleDialog dialog() {
    return SimpleDialog(
      title: Text(
        '会议签到',
        textAlign: TextAlign.center,
      ),
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            '当前会议正在进行中\r\n您是第${widget.data.meetingSignInCount + 1}位进入会议的医生',
            textAlign: TextAlign.center,
          ),
        ),
        Divider(),
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 20,
          alignment: Alignment.center,
          child: FlatButton(
            textColor: ThemeColor.primaryColor,
            onPressed: () {
              //签到接口
              API.shared.server.meetingSign({'taskDetailId': widget.taskDetailId}).then((res) {
                if (res is! DioError) {
                  EasyLoading.showToast('签到成功');
                }
              });
              Navigator.pop(context);
            },
            child: Text(
              '签到',
              style: TextStyle(fontSize: 14),
            ),
          ),
        )
      ],
    );
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
          // AceVideo(controller: _controller),
          Container(child: ChewieVideo(controller: _controller)),
          Expanded(
            child: _renderVideoInfo(),
          ),
        ],
      ),
    );
  }
}
