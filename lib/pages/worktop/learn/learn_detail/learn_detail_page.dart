import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctor/http/common_service.dart';
import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/worktop/learn/learn_detail/constants.dart';
import 'package:doctor/pages/worktop/learn/model/learn_detail_model.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/pages/worktop/learn/learn_detail/learn_detail_item_wiget.dart';
import 'package:http_manager/api.dart';
import 'package:provider/provider.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:doctor/http/server.dart';
import 'package:path_provider/path_provider.dart';

// * @Desc: 计划详情页  */
/// 科室会议
const String TYPE_DEPART = 'DEPART';

/// 沙龙会议
const String TYPE_SALON = 'SALON';

/// 拜访
const String TYPE_VISIT = 'VISIT';

/// 调研
const String TYPE_SURVEY = 'SURVEY';

/// 讲课类型
const String TYPE_DOCTOR_LECTURE = 'DOCTOR_LECTURE';

class LearnDetailPage extends StatefulWidget {
  LearnDetailPage({Key key}) : super(key: key);

  @override
  _LearnDetailPageState createState() => _LearnDetailPageState();
}

class _LearnDetailPageState extends State<LearnDetailPage> {
  DoctorDetailInfoEntity userInfo;
  LearnDetailViewModel _model;

  @override
  void initState() {
    super.initState();
    updateDoctorInfo();
  }

  @override
  void dispose() {
    _model?.dispose();
    super.dispose();
  }

  updateDoctorInfo() {
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    if (model?.data != null) {
      model.queryDoctorInfo();
      userInfo = model.data;
    }
  }

  //确认弹窗
  Future<bool> confirmDialog(int learnProgress) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        print(learnProgress);
        String _text = '当前的学习计划已完成确认提交吗?';
        if (learnProgress == 0) {
          _text = '当前学习计划尚未学习，请在学习后提交';
        } else if (learnProgress != 100) {
          // 学习进度未完成
          _text = '当前学习计划尚未完成，完成度$learnProgress%，确认提交吗？';
        }
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Container(
            padding: EdgeInsets.only(top: 12),
            child: Text(_text),
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
                if (learnProgress == 0) {
                  Navigator.of(context).pop(false);
                } else {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget typeDecoratedBox(String type) {
    Color rendColor = ThemeColor.color72c140;
    if (type == 'VIDEO') {
      rendColor = ThemeColor.color5d9df7;
    } else if (type == 'QUESTIONNAIRE') {
      rendColor = ThemeColor.colorefaf41;
    }
    return DecoratedBox(
        decoration: BoxDecoration(color: rendColor),
        child: Padding(
          // 分别指定四个方向的补白
          padding: const EdgeInsets.fromLTRB(30, 1, 30, 1),
          child: Text(MAP_RESOURCE_TYPE[type],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              )),
        ));
  }

  Widget _buildListItem({
    String label,
    dynamic value,
    Function format,
  }) {
    return new Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ThemeColor.colorFFF3F5F8),
        ),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xff444444),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                )),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Text(
                format != null ? format(value) : value.toString(),
                style: TextStyle(
                  color: Color(0xff222222),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ]),
    );
  }

  // 提交按钮
  String _aceText(type) {
    String text = '提交学习计划';
    if (type == 'DOCTOR_LECTURE') {
      text = '开始讲课';
    }
    return text;
  }

  // 如何录制讲课视频
  Widget _buildLookCourse(data) {
    // 文本字段（`TextField`）组件，允许用户使用硬件键盘或屏幕键盘输入文本。
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Text('当前完成度：${data.learnProgress}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: ThemeColor.primaryColor,
                  ))),
          if (data.taskTemplate == 'DOCTOR_LECTURE')
            GestureDetector(
              child: Text(
                '如何录制讲课视频？',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: ThemeColor.primaryColor,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(RouteManager.LOOK_COURSE_PAGE);
                print('如何录制讲课视频？');
              },
            ),
        ]);
  }

  // 会议进行中
  Widget _meetingStatus(int start, int end) {
    Color rendColor = Color(0xffF6A419);
    String text = '会议进行中';
    int time = new DateTime.now().millisecondsSinceEpoch;
    if (time > end) {
      text = '会议已结束';
      rendColor = Color(0xFFDEDEE1);
    }
    if (time < start) {
      return Container();
    }
    return LearnTextIcon(
      text: text,
      color: rendColor,
      margin: EdgeInsets.only(top: 16, bottom: 16, left: 10),
    );
  }

  // 查看视频
  Widget _renderLookRecording(data) {
    if (data.taskTemplate == 'DOCTOR_LECTURE') {
      if (data.status == 'SUBMIT_LEARN' || data.status == 'ACCEPTED') {
        return Container(
          alignment: Alignment.center,
          // margin: EdgeInsets.fromLTRB(20, 10, 20, 40),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AceButton(
                  text: '查看讲课视频',
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        RouteManager.LOOK_LECTURE_VIDEOS,
                        arguments: {
                          "learnPlanId": data.learnPlanId,
                          "resourceId": data.resources[0].resourceId,
                          'doctorName': data.doctorName,
                        });
                  },
                ),
              ),
            ],
          ),
        );
      }
    }
    return Text('');
  }

  String _obtainTitleByType(String type) {
    switch (type) {
      case TYPE_DEPART:
      case TYPE_SALON:
        return '会议详情';
      case TYPE_VISIT:
        return '拜访详情';
      case TYPE_SURVEY:
        return '调研详情';
      case TYPE_DOCTOR_LECTURE:
        return '讲课邀请详情';
      default:
        return '';
    }
  }

  _uploadVideo(model, arguments, data) async {
    if (data.taskTemplate == 'DOCTOR_LECTURE') {
      var result = await Navigator.of(context).pushNamed(
        RouteManager.LECTURE_VIDEOS,
        arguments: {
          'reLearn': data.reLearn,
          'resourceId': data.resources[0].resourceId,
          'learnPlanId': data.learnPlanId,
          'doctorName': userInfo?.doctorName ?? '',
          'taskName': data.taskName,
          'from': arguments['from'],
          'upFinished': (lectureID) {
            EasyLoading.instance.flash(() async {
              print("-------------");
              print("the lectureID == ${lectureID}");
              var result =
                  await API.shared.server.doctorLectureSharePic("$lectureID");
              var appDocDir = await getApplicationDocumentsDirectory();
              if (Platform.isAndroid) {
                appDocDir = await getExternalStorageDirectory();
              }
              String picPath =
                  appDocDir.path + "/sharePic${DateTime.now().millisecond}.jpg";
              await Dio().download(result["url"], picPath);
              var obj = {"path": picPath, "url": result["codeStr"]};
              var share = json.encode(obj).toString();
              MedcloudsNativeApi.instance().share(share);
              print(result);
            });
          }
        },
      );
      if (result == true) {
        model.initData();
      }
    } else {
      // EasyLoading.showToast('暂未开放'),
      if (data.learnProgress == 0) {
        String _text = '当前学习计划尚未学习，请在学习后提交';
        EasyLoading.showToast(_text);
      } else {
        bool success = await model.bindLearnPlan(
          learnPlanId: data.learnPlanId,
        );
        if (success) {
          EasyLoading.showToast('提交成功');
          // 延时1s执行返回
          Future.delayed(
            Duration(seconds: 1),
            () {
              Navigator.of(context).pop();
            },
          );
        }
      }
    }
  }

  _gotoRecord(LearnDetailItem data) {
    EasyLoading.instance.flash(
      () async {
        var appDocDir = await getApplicationDocumentsDirectory();
        if (Platform.isAndroid) {
          appDocDir = await getExternalStorageDirectory();
        }
        String picPath = appDocDir.path + "/sharePDF";
        var pdf = data.resources[0];
        var resourceData = await API.shared.server.resourceDetail({
          'resourceId': pdf.resourceId,
          'learnPlanId': data.learnPlanId,
        });
        if (resourceData["attachmentOssId"] == null) {
          throw DioError(error: "没有文件");
        }
        var file = await CommonService.getFile({
          'ossIds': [resourceData["attachmentOssId"]]
        });
        var fileURL = file[0]['tmpUrl'];
        await Dio().download(fileURL, picPath);
        UserInfoViewModel model =
            Provider.of<UserInfoViewModel>(context, listen: false);
        var map = {
          "path": picPath,
          "name": data.doctorName,
          "userID": data.doctorUserId,
          "hospital": model.data.hospitalName,
          "title": data.taskName
        };
        var result = json.encode(map);
        MedcloudsNativeApi.instance().record(result.toString());
        MedcloudsNativeApi.instance().addProcessor(
          "uploadLearnVideo",
          (args) async {
            print("call uploadLearnVideo ${args}");
            var obj = json.decode(args);
            print("call 1111111 ${obj}");
            var entity = await OssService.upload(
              obj["path"],
            );
            var result = await API.shared.server.addLectureSubmit(
              {
                'learnPlanId': data.learnPlanId,
                'resourceId': pdf.resourceId,
                'videoTitle': "videoTitle",
                'presenter': data.doctorName,
                'videoOssId': entity.ossId,
              },
            );
            return null;
            //print("the result is ${result}");
          },
        );
      },
    );
  }

  Widget _renderUploadButton(
      LearnDetailViewModel model, arguments, LearnDetailItem data) {
    if (data.reLearn) {
      return Container(
        alignment: Alignment.center,
        // margin: EdgeInsets.fromLTRB(20, 10, 20, 40),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: AceButton(
                text: '查看讲课视频',
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(RouteManager.LOOK_LECTURE_VIDEOS, arguments: {
                    "learnPlanId": data.learnPlanId,
                    "resourceId": data.resources[0].resourceId,
                    'doctorName': data.doctorName,
                  });
                },
              ),
            ),
            Container(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: AceButton(
                color: Color(0xffFECE35),
                shadowColor: Color(0x40FECE35),
                text: '重新讲课',
                onPressed: () {
                  _gotoRecord(data);
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AceButton(
              width: 375,
              // height: 54,
              text: _aceText(data.taskTemplate),
              onPressed: () async {
                if (data.taskTemplate == 'DOCTOR_LECTURE') {
                  _gotoRecord(data);
                } else {
                  this._uploadVideo(model, arguments, data);
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context).settings.arguments;
    _model = LearnDetailViewModel(arguments['learnPlanId']);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: ChangeNotifierProvider<LearnDetailViewModel>.value(
          value: _model,
          child: Consumer<LearnDetailViewModel>(
            builder: (context, model, child) {
              return Text(_obtainTitleByType(model?.data?.taskTemplate ?? ''));
            },
          ),
        ),
      ),
      body: ProviderWidget<LearnDetailViewModel>(
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
          Map dataMap = data.toJson();
          List learnListFields = LEARN_LIST[data.taskTemplate];
          return Container(
            color: ThemeColor.colorFFF3F5F8,
            alignment: Alignment.topCenter,
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (data.taskTemplate == 'DOCTOR_LECTURE' &&
                                  data.reLearnReason != null &&
                                  data.status != 'SUBMIT_LEARN' &&
                                  data.status != 'ACCEPTED')
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  padding: EdgeInsets.fromLTRB(16, 14, 0, 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                '${data.representName}推广员给您留言了：',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color:
                                                      ThemeColor.colorFFfece35,
                                                )),
                                          ]),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${data.reLearnReason}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: ThemeColor.colorFFfece35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                                // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      padding: EdgeInsets.fromLTRB(0, 14, 0, 0),
                                      child: GestureDetector(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text('学习计划信息',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18,
                                                      color: ThemeColor
                                                          .primaryColor,
                                                    )),
                                                // 新
                                                if (data.taskTemplate ==
                                                        'SALON' ||
                                                    data.taskTemplate ==
                                                        'DEPART')
                                                  _meetingStatus(
                                                      data.meetingStartTime,
                                                      data.meetingEndTime)
                                              ],
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    model.collapsed
                                                        ? Icons
                                                            .keyboard_arrow_down
                                                        : Icons
                                                            .keyboard_arrow_up,
                                                    color:
                                                        ThemeColor.primaryColor,
                                                  ),
                                                ]),
                                          ],
                                        ),
                                        onTap: () {
                                          model.toggleCollapsed();
                                        },
                                      ),
                                    ),
                                    ...learnListFields.map((e) {
                                      if (model.collapsed &&
                                          e['notCollapse'] == null) {
                                        return Container();
                                      }
                                      return _buildListItem(
                                          label: e['label'],
                                          value: dataMap[e['field']],
                                          format: e['format']);
                                    }).toList(),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Column(children: [
                                        _buildLookCourse(data),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  padding: EdgeInsets.fromLTRB(16, 14, 0, 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text('资料列表',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: ThemeColor.primaryColor,
                                      ))),
                              Container(
                                margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: PlanDetailList(data),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _renderLookRecording(data),
                      if (data.status != 'SUBMIT_LEARN' &&
                          data.status != 'ACCEPTED')
                        _renderUploadButton(model, arguments, data),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
