import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctor/http/activity.dart';
import 'package:doctor/http/common_service.dart';
import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/activity_detail.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/worktop/learn/lecture_videos/upload_video.dart';
import 'package:doctor/pages/worktop/learn/model/activity_learn_record_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:yyy_route_annotation/yyy_route_annotation.dart';

import '../cache_learn_detail_video_helper.dart';

/// * @Author: duanruilong  * @Date: 2020-10-30 14:49:43  * @Desc: 查看讲课视频

@RoutePage(name: "look_lecture_videos_page")
class LookLectureVideosPage extends StatefulWidget {
  final int activityTaskId;
  final int activityPackageId;
  LookLectureVideosPage(this.activityPackageId, this.activityTaskId);

  @override
  _LookLearnDetailPageState createState() => _LookLearnDetailPageState();
}

class _LookLearnDetailPageState extends State<LookLectureVideosPage> {
  VideoPlayerController _controller;
  DoctorDetailInfoEntity userInfo;
  ActivityDetailEntity _data;
  ActivityLearnRecordingModel _model ;

  updateDoctorInfo() async {
    UserInfoViewModel model =
    Provider.of<UserInfoViewModel>(context, listen: false);
    if (model?.data != null) {
      await model.queryDoctorInfo();
      userInfo = model.data;
    }
    var result =
    await API.shared.activity.packageDetail(widget.activityPackageId);
    _data = ActivityDetailEntity(result);
  }

  @override
  void initState() {
    ActivityLearnRecordingModel(widget.activityTaskId);
    // 在initState中发出请求
    updateDoctorInfo();
    super.initState();
  }

  bool _canSend = true;

  _gotoRecordPage(result) {
    UserInfoViewModel model =
    Provider.of<UserInfoViewModel>(context, listen: false);
    MedcloudsNativeApi.instance().record(result.toString());
    MedcloudsNativeApi.instance().addProcessor(
      "uploadLearnVideo",
          (args) async {
        if (!_canSend) {
          return null;
        }
        _canSend = false;
        try {
          print('----------------$args');
          var obj = json.decode(args);
          CachedVideoInfo info = CachedVideoInfo();
          info.learnPlanId = widget.activityPackageId;
          // info.resourceId = result["attachmentOssId"];
          info.videoTitle = obj['title'] ?? _data.activityName;
          info.duration = int.parse("${obj['duration'] ?? 0}");
          info.presenter = userInfo?.doctorName ?? '';
          info.resourceId = widget.activityTaskId;
          if (Platform.isAndroid) {
            info.path = obj["path"];
          } else {
            String path = obj["path"];
            var prefix = await getApplicationDocumentsDirectory();
            path = path.replaceAll(prefix.path, "");
            info.path = path;
          }
          CachedLearnDetailVideoHelper.cacheVideoInfo(userInfo.doctorUserId,
              CachedLearnDetailVideoHelper.typeActivityVideo, info);
          await _doUpload(info);
        } catch (e) {
          _canSend = true;
          print("e is $e");
          return "网络错误";
        }
        _canSend = true;
        return null;
        //print("the result is ${result}");
      },
    );
  }

  _doUpload(CachedVideoInfo data) async {
    print("do upload");
    var path = data.path;
    if (Platform.isIOS) {
      var prefix = await getApplicationDocumentsDirectory();
      path = prefix.path + path;
    }
    var entity = await OssService.upload(path, showLoading: false);
    var result = await API.shared.activity.saveVideo(
      {
        'activityPackageId': widget.activityPackageId,
        'activityTaskId': widget.activityTaskId,
        'name': data.videoTitle,
        'duration': data.duration,
        'presenter': data.presenter,
        'ossId': entity.ossId,
      },
    );
    print("upload finished");
    _model.initData();
    CachedLearnDetailVideoHelper.cleanVideoCache(
        userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeActivityVideo);
  }
  Future _gogogogogogo() async {
    UserInfoViewModel model =
    Provider.of<UserInfoViewModel>(context, listen: false);
    EasyLoading.instance.flash(
          () async {
        var appDocDir = await getApplicationDocumentsDirectory();
        if (Platform.isAndroid) {
          appDocDir = await getExternalStorageDirectory();
        }
        var resourceData = await API.shared.activity
            .lectureResourceQuery(widget.activityPackageId);
        String picPath = appDocDir.path + "/sharePDF";
        var map = {
          "path": picPath,
          "name": userInfo?.doctorName ?? '',
          "userID": "${model.data.doctorUserId}",
          "hospital": model.data.hospitalName,
          "title": _data.activityName,
          'type': "pdf",
        };
        map["type"] = "pdf";
        var file = await CommonService.getFile({
          'ossIds': [resourceData["attachmentOssId"]]
        });
        var fileURL = file[0]['tmpUrl'];
        await Dio().download(fileURL, picPath);
        var result = json.encode(map);
        Stream<String> pdfFileStream;
        pdfFileStream = File(picPath).openRead(0, 4).transform(utf8.decoder);
        String event = "";
        try {
          event = await pdfFileStream.first;
          if (event.toUpperCase() == '%PDF') {
            this._gotoRecordPage(result);
          } else {
            print("格式为：-  $event");
            EasyLoading.showToast("暂时不支持打开该格式的文件，请到【易学术】小程序上传讲课视频");
          }
        } catch (e) {
          print("格式为：-  $e");
          EasyLoading.showToast("暂时不支持打开该格式的文件，请到【易学术】小程序上传讲课视频");
        }
      },
    );
  }

  /// 渲染视频信息
  Widget _renderVideoInfo(ActivityVideoLectureDetail data, _doctorName) {
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
          if (data.status == "REJECT")
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.only(left: 16, right: 16, top: 12),
              // color: Colors.red,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Color(0xFFFEF4D5),
                border: Border.all(color: Color(0xFFFECE35)),
              ),
              child: Text(
                "驳回理由：${data.rejectReason ?? ''}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFECE35),
                ),
              ),
            ),
          Container(
            padding: commonPadding,
            alignment: Alignment.centerLeft,
            child: Text(
              data.name,
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
    return ProviderWidget<ActivityLearnRecordingModel>(
      model: _model,
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return Container();
        }
        if (model.isError || model.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model.initData);
        }
        var data = model.data;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('讲课视频'),
          ),
          body: Container(
            alignment: Alignment.topCenter,
            // color: ThemeColor.colorFFF3F5F8,
            // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: [
                Container(
                  child: Stack(
                    children: [
                      UploadActivityVideoDetail(data, _controller),
                      // if (data.status == 'WAIT_VERIFY')
                      //   Positioned(
                      //     child: Container(
                      //       width: double.infinity,
                      //       alignment: Alignment.center,
                      //       padding: EdgeInsets.symmetric(vertical: 10),
                      //       margin:
                      //           EdgeInsets.only(left: 16, right: 16, top: 12),
                      //       decoration: BoxDecoration(
                      //           color: Color(0xFFDFDFDF),
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(4)),
                      //           border: Border.all(color: Color(0xFF444444))),
                      //       child: Text(
                      //         "待审核",
                      //         style: TextStyle(
                      //           fontSize: 14,
                      //           color: Color(0xFF444444),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // if (data.status == 'VERIFIED')
                      //   Positioned(
                      //     child: Container(
                      //       width: double.infinity,
                      //       alignment: Alignment.center,
                      //       padding: EdgeInsets.symmetric(vertical: 10),
                      //       margin:
                      //           EdgeInsets.only(left: 16, right: 16, top: 12),
                      //       decoration: BoxDecoration(
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(4)),
                      //           color: Color(0xFFE0F4D5),
                      //           border: Border.all(color: Color(0xFF5AC624))),
                      //       child: Text(
                      //         "审核通过",
                      //         style: TextStyle(
                      //           fontSize: 14,
                      //           color: Color(0xFF5AC624),
                      //         ),
                      //       ),
                      //     ),
                      //   )
                    ],
                  ),
                ),
                Expanded(child: _renderVideoInfo(data, '')),
                if (data.status == "REJECT")
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: AceButton(
                      text: "重新录制",
                      onPressed: () async {
                        UserInfoViewModel model =
                            Provider.of<UserInfoViewModel>(context,
                                listen: false);
                        await model.queryDoctorInfo();
                        DoctorDetailInfoEntity userInfo = model.data;
                        var videoData = await CachedLearnDetailVideoHelper
                            .getCachedVideoInfo(userInfo.doctorUserId,
                                CachedLearnDetailVideoHelper.typeActivityVideo);
                        bool isSamePackage =
                            await CachedLearnDetailVideoHelper.hasCachedVideo(
                                userInfo.doctorUserId,
                                CachedLearnDetailVideoHelper.typeActivityVideo,
                                id: data.activityPackageId);
                        if (isSamePackage) {
                          Navigator.pop(context);
                          return;
                        } else if (videoData != null) {
                          {
                            _showUploadVideoAlert(
                              "您暂时无法录制新的讲课视频",
                              "您有一个未完成的讲课邀请任务是否立即查看详情",
                              () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ActivityDetail(videoData.learnPlanId,
                                      TYPE_LECTURE_VIDEO);
                                }));
                              },
                              cancel: "暂不查看",
                              done: "查看详情",
                            );
                          }
                        } else {
                          _gogogogogogo();
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff107bfd),
                borderRadius: BorderRadius.all(Radius.circular(22)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 1,
                    color: Color(0x33107BFD),
                    offset: Offset(1.2, 3),
                  ),
                ],
              ),
              width: 44,
              height: 44,
              child: Container(
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
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              EasyLoading.instance.flash(() async {
                var result = await API.shared.activity
                    .doctorLectureSharePic(model.data.activityTaskId);
                var appDocDir = await getApplicationDocumentsDirectory();
                if (Platform.isAndroid) {
                  appDocDir = await getExternalStorageDirectory();
                }
                String picPath = appDocDir.path + "/sharePic";
                await Dio().download(result["url"], picPath);
                var obj = {"path": picPath, "url": result["codeStr"]};
                var share = json.encode(obj).toString();
                MedcloudsNativeApi.instance().share(share);
                print("------");
              });
            },
          ),
          floatingActionButtonLocation: _FloatingButtonLocation(
            FloatingActionButtonLocation.endFloat,
            -10,
            -60,
          ),
          floatingActionButtonAnimator: _NoScalingAnimation(),
        );
      },
    );
  }

  _showUploadVideoAlert(String title, String desc, Function action,
      {String cancel = "取消", String done = "确定"}) {
    showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return WillPopScope(
          child: CupertinoAlertDialog(
            content: Container(
              padding: EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff444444),
                    ),
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xfff57575),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  cancel,
                  style: TextStyle(
                    color: ThemeColor.colorFF444444,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text(
                  done,
                  style: TextStyle(
                    color: ThemeColor.colorFF52C41A,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(false);
                  action();
                },
              ),
            ],
          ),
          onWillPop: () async => false,
        );
      },
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
