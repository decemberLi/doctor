import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:doctor/http/common_service.dart';
import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/oss_file_entity.dart';
import 'package:doctor/pages/worktop/learn/learn_upload_record/upload_video.dart';
import 'package:doctor/pages/worktop/learn/model/learn_record_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/pages/worktop/service.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/image_picker_helper.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

class LearnUploadRecordPage extends StatefulWidget {
  // final ResourceModel data;
  // LearnUploadRecordPage(this.data);
  LearnUploadRecordPage({Key key}) : super(key: key);

  @override
  _LearnDetailPageState createState() => _LearnDetailPageState();
}

class _LearnDetailPageState extends State<LearnUploadRecordPage> {
  String _upDoctorName;
  String _upTaskName;
  String _videoOssId;

  VideoPlayerController _controller;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // 在initState中发出请求
    _upDoctorName = '';
    _upTaskName = '';
    super.initState();
  }

  Future<void> _playVideo(PickedFile file, videdata) async {
    if (file != null && mounted) {
      _controller = VideoPlayerController.file(File(file.path));
      await _controller.setVolume(1.0);
      OssFileEntity entity = await OssService.upload(file.path);

      print('entity:>>${entity}');
      print('file.path:>>${file.path}');
      print('_controller:>>$_controller');
      if (entity != null) {
        _videoOssId = entity.ossId;
        Map<String, dynamic> reoptions = {
          "videoTitle": entity.name,
          "videoOssId": entity.ossId,
          "videoUrl": entity.url,
        };

        LearnRecordingItem option = LearnRecordingItem.fromJson(reoptions);
        videdata.videoUrl = option.videoUrl;
        videdata.videoOssId = option.videoOssId;
      }
      setState(() {});
    }
  }

  Future<void> _selectVideos(videdata) async {
    try {
      // ignore: deprecated_member_use
      // _video = await ImagePicker.pickVideo(source: ImageSource.gallery);
      // print('选取视频：' + _video.toString());

      final PickedFile file = await _picker.getVideo(
          source: ImageSource.gallery,
          maxDuration: const Duration(seconds: 10));
      await _playVideo(file, videdata);
    } on PlatformException {}
  }

  // 选择视频
  // _selectPicture() async {
  // try {
  //   _galleryMode = GalleryMode.video;
  //   _listVideoPaths = await ImagePickers.pickerPaths(
  //     galleryMode: _galleryMode,
  //     selectCount: 2,
  //     showCamera: true,
  //   );
  //   setState(() {});
  //   print(_listVideoPaths);
  // } on PlatformException {}
  // }

  // 视频播放
  Widget _videoBox(dynamic videdata) {
    if (videdata.videoUrl != null) {
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
                _selectVideos(videdata);
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
                  EasyLoading.showToast('添加视频');
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
  void _onUpVideoClick(data, learnPlanId, resourceId) async {
    bool bindConfirm = await confirmDialog();
    if (bindConfirm) {
      await addLectureSubmit({
        'learnPlanId': learnPlanId,
        'resourceId': resourceId,
        'videoTitle': _upTaskName != null ? _upTaskName : data.videoTitle,
        'presenter': _upDoctorName != null ? _upDoctorName : data.presenter,
        'videoOssId': _videoOssId != null ? _videoOssId : data.videoOssId,
      }).then((res) {
        EasyLoading.showToast('提交成功');
        // 延时1s执行返回
        Future.delayed(Duration(seconds: 1), () {
          // 回到列表
          Navigator.of(context).pushNamed(RouteManager.LEARN_LIST);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    String learnPlanId;
    String resourceId;
    if (obj != null) {
      learnPlanId = obj["learnPlanId"].toString();
      resourceId = obj['resourceId'].toString();
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('讲课视频上传'),
        ),
        body: ProviderWidget<LearnRecordingModel>(
            model: LearnRecordingModel(learnPlanId, resourceId),
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
                  color: ThemeColor.colorFFF3F5F8,
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
                                  textAlign: TextAlign.right,
                                  controller: TextEditingController(
                                      text: data.presenter),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10.0),
                                  ),
                                  style:
                                      TextStyle(color: ThemeColor.primaryColor),
                                  onChanged: (value) {
                                    _upTaskName = value;
                                    print("$_upTaskName'11输入框 组件: $value");
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
                                  textAlign: TextAlign.right,
                                  controller: TextEditingController(
                                      text: data.videoTitle),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: InputBorder.none,
                                  ),
                                  style:
                                      TextStyle(color: ThemeColor.primaryColor),
                                  onChanged: (value) {
                                    _upDoctorName = value;
                                    print("$_upDoctorName'输入框 组件: $value");
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
                                      _onUpVideoClick(
                                          data, learnPlanId, resourceId)
                                    }),
                          ],
                        ),
                      ],
                    ),
                  ));
            }));
  }
}
