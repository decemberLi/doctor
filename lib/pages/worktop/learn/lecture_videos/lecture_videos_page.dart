import 'dart:io';

import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/pages/worktop/learn/lecture_videos/upload_video.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/pages/worktop/learn_plan_page.dart';
import 'package:doctor/pages/worktop/service.dart';
import 'package:doctor/provider/provider_widget.dart';
// import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

/// * @Author: duanruilong  * @Date: 2020-10-30 14:49:43  * @Desc: 上传讲课视频  */ lecture_videos

class LectureVideosPage extends StatefulWidget {
  LectureVideosPage({Key key}) : super(key: key);
  @override
  _LearnDetailPageState createState() => _LearnDetailPageState();
}

class _LearnDetailPageState extends State<LectureVideosPage> {
  VideoPlayerController _controller;
  final ImagePicker _picker = ImagePicker();
  PickedFile _selectVideoData;

  String _doctorName;
  String _taskName;
  String _showDoctorName;
  String _showTaskName;

  FocusNode taskNameFocusNode = FocusNode();
  FocusNode doctorNameFocusNode = FocusNode();

  @override
  void initState() {
    // 在initState中发出请求
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    taskNameFocusNode.dispose();
    doctorNameFocusNode.dispose();
  }

  Future<void> _selectVideos() async {
    try {
      final PickedFile file = await _picker.getVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 10));
      if (file != null && mounted) {
        _controller = VideoPlayerController.file(File(file.path));
        await _controller.setVolume(1.0);
        setState(() {
          _selectVideoData = file;
        });
      }
    } on PlatformException {}
  }

  // 视频播放
  Widget _videoBox(dynamic videdata) {
    if (_controller != null || videdata?.videoUrl != null) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 40),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(20),
                child: UploadVideoDetail(videdata, _controller)),
            GestureDetector(
              child: Text('重新选择视频',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: ThemeColor.primaryColor,
                  )),
              onTap: () {
                // 收起键盘
                FocusScope.of(context).requestFocus(FocusNode());
                _selectVideos();
              },
            ),
          ],
        ),
      );
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 60, 0, 60),
              child: GestureDetector(
                child: Image.asset(
                  'assets/images/add_video.png',
                  width: 150,
                  height: 87,
                ),
                onTap: () {
                  // 收起键盘
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectVideos();
                },
              ),
            ),
          ]);
    }
  }

//确认弹窗
  Future<bool> confirmDialog() {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text('确认要上传讲课视频吗？'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
            ),
            FlatButton(
              child: Text(
                "确定",
                style: TextStyle(
                  color: ThemeColor.primaryColor,
                ),
              ),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  // 上传提交
  void _onUpVideoClick(data, learnPlanId, resourceId, from) async {
    var _videoTitle = _taskName;
    var _presenter = _doctorName;
    if (_showTaskName != null && _taskName == null) {
      _videoTitle = _showTaskName;
    }
    if (_showDoctorName != null && _doctorName == null) {
      _presenter = _showDoctorName;
    }
    if (_selectVideoData == null && data == null) {
      EasyLoading.showToast('请选择视频');
      return;
    }
    if (_videoTitle == null || !_videoTitle.isNotEmpty) {
      EasyLoading.showToast('请填写视频标题');
      return;
    }
    if (_presenter == null || !_presenter.isNotEmpty) {
      EasyLoading.showToast('请填写视频主讲人');
      return;
    }
    bool bindConfirm = await confirmDialog();
    if (bindConfirm) {
      OssFileEntity entity;
      if (_selectVideoData != null)
        entity = await OssService.upload(_selectVideoData.path);

      await addLectureSubmit({
        'learnPlanId': learnPlanId,
        'resourceId': resourceId,
        'videoTitle': _videoTitle,
        'presenter': _presenter,
        'videoOssId': entity != null ? entity.ossId : data.videoOssId,
      }).then((res) {
        EasyLoading.showToast('提交成功');
        // 延时1s执行返回
        Future.delayed(Duration(seconds: 1), () {
          if (from != null && from == 'work_top') {
            // 工作台进入详情页--只有返回
            //  第一个参数表示将要加入栈中的页面，第二个参数表示栈中要保留的页面底线
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LearnPlanPage()),
                ModalRoute.withName('/'));
          } else {
            // 点击回到learn_page，连带着之前也一起退出
            Navigator.of(context).popUntil(ModalRoute.withName('/learn_page'));
          }
          // Navigator.of(context).pushNamed(RouteManager.LEARN_PAGE);
        });
      }).catchError((error) {
        EasyLoading.showToast(error.errorMsg);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    String learnPlanId;
    String resourceId;
    bool reLearn;
    if (obj != null) {
      learnPlanId = obj["learnPlanId"].toString();
      resourceId = obj['resourceId'].toString();
      reLearn = obj['reLearn'];
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('讲课视频上传'),
        ),
        body: ProviderWidget<LearnRecordingModel>(
            model: LearnRecordingModel(learnPlanId, resourceId, reLearn),
            onModelReady: (model) => model.initData(),
            builder: (context, model, child) {
              if (model.isBusy) {
                return Container();
              }
              // if (model.isError || model.isEmpty) {
              //   return ViewStateEmptyWidget(onPressed: model.initData);
              // }
              var data = model.data;

              _showDoctorName = _doctorName;
              _showTaskName = _taskName;
              if (data != null && data?.videoTitle != null) {
                if (_taskName == null && data?.videoTitle != null) {
                  _showTaskName = data.videoTitle;
                }
                if (_doctorName == null && data?.presenter != null) {
                  _showDoctorName = data.presenter;
                }
              } else {
                if (_taskName == null) {
                  _showTaskName = obj['taskName'];
                }
                if (_doctorName == null) {
                  _showDoctorName = obj['doctorName'];
                }
              }
              return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // 触摸收起键盘
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    alignment: Alignment.topCenter,
                    color: ThemeColor.colorFFF3F5F8,
                    child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: ListTile(
                                title: TextField(
                                  keyboardType: TextInputType.multiline, //多行
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  textAlign: TextAlign.right,
                                  controller: TextEditingController(
                                      text: _showTaskName),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10.0),
                                  ),
                                  autofocus: false,
                                  focusNode: taskNameFocusNode,
                                  style:
                                      TextStyle(color: ThemeColor.primaryColor),
                                  onChanged: (value) {
                                    _taskName = value;
                                  },
                                ),
                                leading: Text('视频标题',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: ThemeColor.primaryColor,
                                    )),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: ListTile(
                                title: TextField(
                                  keyboardType: TextInputType.multiline, //多行
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],

                                  textAlign: TextAlign.right,
                                  controller: TextEditingController(
                                      text: _showDoctorName),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: InputBorder.none,
                                  ),
                                  autofocus: false,
                                  focusNode: doctorNameFocusNode,
                                  style:
                                      TextStyle(color: ThemeColor.primaryColor),

                                  onChanged: (value) {
                                    _doctorName = value;
                                  },
                                ),
                                leading: Text('主讲人',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: ThemeColor.primaryColor,
                                    )),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                                    padding: EdgeInsets.fromLTRB(16, 10, 0, 10),
                                    child: Text('上传视频',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: ThemeColor.primaryColor,
                                        )))
                              ],
                            ),
                            _videoBox(data),
                            AceButton(
                                text: '上传并提交',
                                onPressed: () => {
                                      // 收起键盘
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode()),
                                      _onUpVideoClick(data, learnPlanId,
                                          resourceId, obj['from'])
                                    }),
                          ],
                        ),
                      ],
                    ),
                  ));
            }));
  }
}
