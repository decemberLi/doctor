import 'package:dio/dio.dart';
import 'package:doctor/pages/worktop/learn/lecture_videos/upload_video.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/rendering.dart';
import 'package:doctor/http/server.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';

/// * @Author: duanruilong  * @Date: 2020-10-30 14:49:43  * @Desc: 查看讲课视频

class LookLectureVideosPage extends StatefulWidget {
  LookLectureVideosPage({Key key}) : super(key: key);

  @override
  _LookLearnDetailPageState createState() => _LookLearnDetailPageState();
}

class _LookLearnDetailPageState extends State<LookLectureVideosPage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    // 在initState中发出请求
    super.initState();
  }

  /// 渲染视频信息
  Widget _renderVideoInfo(data, _doctorName) {
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
    var _presenter = _doctorName;
    if (data.presenter != null && data.presenter != '') {
      _presenter = data.presenter;
    }
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
              data.videoTitle,
              style: boldTextStyle,
            ),
          ),
          Container(
            padding: commonPadding,
            alignment: Alignment.centerLeft,
            child: Text(
              '主讲人：$_presenter',
              style: lightTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    String learnPlanId;
    String resourceId;
    String _doctorName;

    if (obj != null) {
      learnPlanId = obj["learnPlanId"].toString();
      resourceId = obj['resourceId'].toString();
      _doctorName = obj['doctorName'];
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('资料详情'),
        ),
        body: ProviderWidget<LearnRecordingModel>(
            model: LearnRecordingModel(learnPlanId, resourceId, true),
            onModelReady: (model) => model.initData(),
            builder: (context, model, child) {
              if (model.isBusy) {
                return Container();
              }
              if (model.isError || model.isEmpty) {
                return ViewStateEmptyWidget(onPressed: model.initData);
              }
              var data = model.data;
              return Container(
                alignment: Alignment.topCenter,
                // color: ThemeColor.colorFFF3F5F8,
                color: Color.fromRGBO(0, 0, 0, 1),
                // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Container(child: UploadVideoDetail(data, _controller)),
                    Expanded(child: _renderVideoInfo(data, _doctorName)),
                  ],
                ),
              );
            },),
      floatingActionButton: Container(
        width: 44,
        height: 44,
        child: FloatingActionButton(
          backgroundColor: Color(0xff107bfd),
          onPressed: () {
            EasyLoading.instance.flash(() async {
              var result =
              await API.shared.server.doctorLectureSharePic(resourceId);
              var appDocDir = await getApplicationDocumentsDirectory();
              String picPath = appDocDir.path + "/sharePic";
              await Dio().download(result["url"], picPath);
              var channel = MethodChannel("share");
              channel.invokeMethod("show",{"path":picPath,"url":result["codeStr"]});
              print("------");
              print(result);
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/share.png",
                width: 20,
                height: 17,
              ),
              Container(
                height: 3,
              ),
              Text(
                "分享",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: _FloatingButtonLocation(
        FloatingActionButtonLocation.endFloat,
        -10,
        -60,
      ),
      floatingActionButtonAnimator: _NoScalingAnimation(),
    );
  }
}


class _FloatingButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  _FloatingButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
class _NoScalingAnimation extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {
    return end;
  }

  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }
}
