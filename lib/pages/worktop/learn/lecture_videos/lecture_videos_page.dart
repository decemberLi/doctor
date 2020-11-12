import 'dart:io';

import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/pages/worktop/learn/lecture_videos/upload_video.dart';
import 'package:doctor/pages/worktop/learn/model/learn_record_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/pages/worktop/learn_plan_page.dart';
import 'package:doctor/pages/worktop/service.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/route/route_manager.dart';

// import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/app_utils.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/debounce.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/utils/no_wifi_notice_helper.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
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
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController presenterController = TextEditingController();
  VideoPlayerController _controller;
  File _selectVideoData;

  final ImagePicker _picker = ImagePicker();

  String learnPlanId;
  String resourceId;
  bool reLearn = false;
  LearnRecordingItem data = LearnRecordingItem();

  FocusNode taskNameFocusNode = FocusNode();
  FocusNode doctorNameFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      this.initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    taskNameFocusNode.dispose();
    doctorNameFocusNode.dispose();
  }

  initData() async {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    if (obj != null) {
      learnPlanId = obj["learnPlanId"].toString();
      resourceId = obj['resourceId'].toString();
      reLearn = obj['reLearn'];
    }
    if (!reLearn) {
      titleController.text = obj['taskName'];
      presenterController.text = obj['doctorName'];
      return;
    }
    try {
      var result = await http.post('/doctor-lecture/detail', params: {
        'learnPlanId': this.learnPlanId,
        'resourceId': this.resourceId,
      });

      setState(() {
        this.data = LearnRecordingItem.fromJson(result);
        titleController.text = this.data.videoTitle;
        presenterController.text = this.data.presenter;
        print(this.data.toJson());
      });
    } catch (e) {
      return e;
    }
  }

  Future<void> _selectVideos() async {
    try {
      // final File file = await ImageHelper.pickSingleVideo(
      //   context,
      //   source: 1,
      // );
      await Future.delayed(Duration(milliseconds: 500));
      final PickedFile file = await _picker.getVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 10));
      if (file != null && mounted) {
        EasyLoading.show(status: '视频压缩中...');
        MediaInfo mediaInfo = await VideoCompress.compressVideo(
          file.path,
          quality: VideoQuality.DefaultQuality,
          frameRate: 20,
          deleteOrigin: false, // It's false by default
          includeAudio: true,
        );
        print(mediaInfo.toJson().toString());
        _controller = VideoPlayerController.file(mediaInfo.file);
        await _controller.setVolume(1.0);
        EasyLoading.dismiss();
        setState(() {
          _selectVideoData = mediaInfo.file;
        });
      }
    } catch (e) {
      EasyLoading.showToast('压缩失败');
      print(e.toString());
    }
  }

  // 视频播放
  Widget _videoBox() {
    if (_controller != null || this.data?.videoUrl != null) {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 40),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(20),
                child: UploadVideoDetail(this.data, _controller)),
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
                onTap: debounce(() {
                  // 收起键盘
                  //FocusScope.of(context).requestFocus(FocusNode());
                  _controller?.pause();
                  _selectVideos();
                }),
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
  void _onUpVideoClick() async {
    _controller.pause();
    final form = _formKey.currentState;
    form.save();
    if (_selectVideoData == null) {
      EasyLoading.showToast('请选择视频');
      return;
    }
    if (this.data.videoTitle.isEmpty) {
      EasyLoading.showToast('请填写视频标题');
      return;
    }
    if (this.data.presenter.isEmpty) {
      EasyLoading.showToast('请填写视频主讲人');
      return;
    }
    bool bindConfirm = false;
    var onlyWifi = AppUtils.sp.getBool(ONLY_WIFI) ?? true;
    if (onlyWifi) {
      bindConfirm = await NoWifiNoticeHelper.checkConnect(
        context: context,
        message: '当前使用非WIFI网络，上传将消耗流量，确认要上传该视频吗?',
      );
      if (!bindConfirm) {
        return;
      }
    } else {
      bindConfirm = await confirmDialog();
    }
    if (bindConfirm) {
      OssFileEntity entity;
      if (_selectVideoData != null) {
        entity = await OssService.upload(
          _selectVideoData.path,
        );
        await VideoCompress.deleteAllCache();
      }

      await addLectureSubmit({
        'learnPlanId': learnPlanId,
        'resourceId': resourceId,
        'videoTitle': this.data.videoTitle,
        'presenter': this.data.presenter,
        'videoOssId': entity != null ? entity.ossId : data.videoOssId,
      }).then((res) {
        EasyLoading.showToast('提交成功');
        // 延时1s执行返回
        Future.delayed(Duration(seconds: 1), () {
          dynamic obj = ModalRoute.of(context).settings.arguments;
          String from = obj['from'];
          if (from != null && from == 'work_top') {
            // 工作台进入详情页--只有返回
            //  第一个参数表示将要加入栈中的页面，第二个参数表示栈中要保留的页面底线
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LearnPlanPage()),
                ModalRoute.withName(RouteManager.HOME));
            // Navigator.of(context)
            //     .popUntil(ModalRoute.withName(RouteManager.HOME));
          } else {
            // 点击回到learn_page，连带着之前也一起退出
            Navigator.of(context)
                .popUntil(ModalRoute.withName(RouteManager.LEARN_PAGE));
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('讲课视频上传'),
      ),
      body: GestureDetector(
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                          // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: ListTile(
                            title: TextFormField(
                              controller: titleController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                              autofocus: false,
                              onSaved: (val) => this.data.videoTitle = val,
                              // focusNode: taskNameFocusNode,
                              style: TextStyle(color: ThemeColor.primaryColor),
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
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: ListTile(
                            title: TextFormField(
                              controller: presenterController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: InputBorder.none,
                              ),
                              autofocus: false,
                              onSaved: (val) => this.data.presenter = val,
                              // focusNode: doctorNameFocusNode,
                              style: TextStyle(color: ThemeColor.primaryColor),
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
                      ],
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
                  _videoBox(),
                  AceButton(
                    text: '上传并提交',
                    onPressed: () => {
                      // 收起键盘
                      FocusScope.of(context).requestFocus(FocusNode()),
                      _onUpVideoClick()
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
