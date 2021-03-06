import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctor/common/statistics/biz_tracker.dart';
import 'package:doctor/http/common_service.dart';
import 'package:doctor/http/oss_service.dart';
import 'package:doctor/http/server.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/worktop/learn/cache_learn_detail_video_helper.dart';
import 'package:doctor/pages/worktop/learn/learn_detail/constants.dart';
import 'package:doctor/pages/worktop/learn/learn_detail/learn_detail_item_wiget.dart';
import 'package:doctor/pages/worktop/learn/model/learn_detail_model.dart';
import 'package:doctor/pages/worktop/learn/research_detail/research_detail.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:yyy_route_annotation/yyy_route_annotation.dart';

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

///
const String TYPE_PRODUCT_PROFESSIONAL_SHARE = "PRODUCT_PROFESSIONAL_SHARE";
const String TYPE_PRODUCT_DOCTOR_EDUCATION = "PRODUCT_DOCTOR_EDUCATION";

@RoutePage(name: "learn_detail_page")
class LearnDetailPage extends StatefulWidget {
  int learnPlanId;

  LearnDetailPage(this.learnPlanId, {Key key}) : super(key: key);

  @override
  _LearnDetailPageState createState() => _LearnDetailPageState();
}

class _LearnDetailPageState extends State<LearnDetailPage> {
  DoctorDetailInfoEntity userInfo;
  LearnDetailViewModel _model;
  bool hasVideo = false;
  int videoDuration = 0;

  @override
  void initState() {
    super.initState();
    updateDoctorInfo();
  }

  updateDoctorInfo() async {
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    if (model?.data != null) {
      model.queryDoctorInfo();
      userInfo = model.data;
    }
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                MedcloudsNativeApi.instance().openWebPage(
                    "https://mp.weixin.qq.com/s/YprfqD8GdSHCMvtW_LJx9Q");
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
                  shadowColor: Color(0x00000000),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        RouteManagerOld.LOOK_LECTURE_VIDEOS,
                        arguments: {
                          "learnPlanId": data.learnPlanId,
                          "resourceId": data.resources[0].resourceId,
                          'doctorName': userInfo?.doctorName ?? '',
                        });
                  },
                ),
              ),
            ],
          ),
        );
      }
    }
    return Container();
  }

  String _obtainTitleByType(String type) {
    switch (type) {
      case TYPE_DEPART:
      case TYPE_SALON:
      case TYPE_PRODUCT_DOCTOR_EDUCATION:
      case TYPE_PRODUCT_PROFESSIONAL_SHARE:
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

  _submit(model, data) async {
    // EasyLoading.showToast('暂未开放'),
    if (data.learnProgress == 0) {
      String _text = '当前学习计划尚未学习，请在学习后提交';
      EasyLoading.showToast(_text);
    } else {
      bool success = await model.bindLearnPlan(
        learnPlanId: data.learnPlanId,
      );
      if (success) {
        UserInfoViewModel model =
            Provider.of<UserInfoViewModel>(context, listen: false);
        eventTracker(Event.PLAN_SUBMIT, {
          "learn_plan_id": "${data?.learnPlanId}",
          "user_id": "${model?.data?.doctorUserId}"
        });
        EasyLoading.showSuccess('提交成功');
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

  _uploadFinish(lectureID) {
    EasyLoading.instance.flash(() async {
      print("-------------");
      print("the lectureID == $lectureID");
      var result = await API.shared.server.doctorLectureSharePic("$lectureID");
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

  _gotoRecord(LearnDetailItem data) async {
    if (EasyLoading.isShow) {
      return;
    }
    var videoData = await CachedLearnDetailVideoHelper.getCachedVideoInfo(
        userInfo.doctorUserId,CachedLearnDetailVideoHelper.typeLearnVideo);
    if (videoData != null) {
      _showUploadVideoAlert(
        "您暂时无法录制新的讲课视频",
        "您有一个未完成的讲课邀请任务是否立即查看详情",
        () {
          Navigator.of(context).pushNamed(
            RouteManagerOld.LEARN_DETAIL,
            arguments: {
              'learnPlanId': videoData.learnPlanId,
            },
          );
        },
        cancel: "暂不查看",
        done: "查看详情",
      );
      return;
    }
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
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
        var map = {
          "path": picPath,
          "name": userInfo?.doctorName ?? '',
          "userID": model.data.doctorUserId,
          "hospital": model.data.hospitalName,
          "title": data.taskName,
          'type': "pdf",
        };
        if (resourceData["attachmentOssId"] == null) {
          map["type"] = "html";
          var result = json.encode(map);
          var html = _getHTML(resourceData["title"], resourceData["context"]);
          var file = File(picPath);
          file.writeAsString(html);
          this._gotoRecordPage(pdf, data, result);
        } else {
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
              this._gotoRecordPage(pdf, data, result);
            } else {
              print("格式为：-  $event");
              EasyLoading.showToast("暂时不支持打开该格式的文件，请到【易学术】小程序上传讲课视频");
            }
          } catch (e) {
            print("格式为：-  $e");
            EasyLoading.showToast("暂时不支持打开该格式的文件，请到【易学术】小程序上传讲课视频");
          }
        }
      },
    );
  }

  _getHTML(title, context) {
    String articleHtml =
        r'<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><meta name="renderer" content="webkit"><meta name="force-rendering" content="webkit"><meta name="viewport" content="initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no"><style>body{margin:0;background:#f3f5f8;padding:16px 16px 60px}.article{padding:14px 16px 16px;background:#fff;border-radius:8px}.title{color:#222;font-size:16px;text-align:center;font-weight:500;margin-bottom:12px}.ql-editor blockquote,.ql-editor h1,.ql-editor h2,.ql-editor h3,.ql-editor h4,.ql-editor h5,.ql-editor h6,.ql-editor ol,.ql-editor p,.ql-editor pre,.ql-editor ul{margin:0;padding:0;counter-reset:list-1 list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor ol,.ql-editor ul{padding-left:1.5em}.ql-editor ol>li,.ql-editor ul>li{list-style-type:none}.ql-editor ul>li::before{content:"\2022"}.ql-editor ul[data-checked=false],.ql-editor ul[data-checked=true]{pointer-events:none}.ql-editor ul[data-checked=false]>li *,.ql-editor ul[data-checked=true]>li *{pointer-events:all}.ql-editor ul[data-checked=false]>li::before,.ql-editor ul[data-checked=true]>li::before{color:#777;cursor:pointer;pointer-events:all}.ql-editor ul[data-checked=true]>li::before{content:"\2611"}.ql-editor ul[data-checked=false]>li::before{content:"\2610"}.ql-editor li::before{display:inline-block;white-space:nowrap;width:1.2em}.ql-editor li:not(.ql-direction-rtl)::before{margin-left:-1.5em;margin-right:.3em;text-align:right}.ql-editor li.ql-direction-rtl::before{margin-left:.3em;margin-right:-1.5em}.ql-editor ol li:not(.ql-direction-rtl),.ql-editor ul li:not(.ql-direction-rtl){padding-left:1.5em}.ql-editor ol li.ql-direction-rtl,.ql-editor ul li.ql-direction-rtl{padding-right:1.5em}.ql-editor ol li{counter-reset:list-1 list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9;counter-increment:list-0}.ql-editor ol li:before{content:counter(list-0,decimal) ". "}.ql-editor ol li.ql-indent-1{counter-increment:list-1}.ql-editor ol li.ql-indent-1:before{content:counter(list-1,lower-alpha) ". "}.ql-editor ol li.ql-indent-1{counter-reset:list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-2{counter-increment:list-2}.ql-editor ol li.ql-indent-2:before{content:counter(list-2,lower-roman) ". "}.ql-editor ol li.ql-indent-2{counter-reset:list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-3{counter-increment:list-3}.ql-editor ol li.ql-indent-3:before{content:counter(list-3,decimal) ". "}.ql-editor ol li.ql-indent-3{counter-reset:list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-4{counter-increment:list-4}.ql-editor ol li.ql-indent-4:before{content:counter(list-4,lower-alpha) ". "}.ql-editor ol li.ql-indent-4{counter-reset:list-5 list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-5{counter-increment:list-5}.ql-editor ol li.ql-indent-5:before{content:counter(list-5,lower-roman) ". "}.ql-editor ol li.ql-indent-5{counter-reset:list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-6{counter-increment:list-6}.ql-editor ol li.ql-indent-6:before{content:counter(list-6,decimal) ". "}.ql-editor ol li.ql-indent-6{counter-reset:list-7 list-8 list-9}.ql-editor ol li.ql-indent-7{counter-increment:list-7}.ql-editor ol li.ql-indent-7:before{content:counter(list-7,lower-alpha) ". "}.ql-editor ol li.ql-indent-7{counter-reset:list-8 list-9}.ql-editor ol li.ql-indent-8{counter-increment:list-8}.ql-editor ol li.ql-indent-8:before{content:counter(list-8,lower-roman) ". "}.ql-editor ol li.ql-indent-8{counter-reset:list-9}.ql-editor ol li.ql-indent-9{counter-increment:list-9}.ql-editor ol li.ql-indent-9:before{content:counter(list-9,decimal) ". "}.ql-editor .ql-indent-1:not(.ql-direction-rtl){padding-left:3em}.ql-editor li.ql-indent-1:not(.ql-direction-rtl){padding-left:4.5em}.ql-editor .ql-indent-1.ql-direction-rtl.ql-align-right{padding-right:3em}.ql-editor li.ql-indent-1.ql-direction-rtl.ql-align-right{padding-right:4.5em}.ql-editor .ql-indent-2:not(.ql-direction-rtl){padding-left:6em}.ql-editor li.ql-indent-2:not(.ql-direction-rtl){padding-left:7.5em}.ql-editor .ql-indent-2.ql-direction-rtl.ql-align-right{padding-right:6em}.ql-editor li.ql-indent-2.ql-direction-rtl.ql-align-right{padding-right:7.5em}.ql-editor .ql-indent-3:not(.ql-direction-rtl){padding-left:9em}.ql-editor li.ql-indent-3:not(.ql-direction-rtl){padding-left:10.5em}.ql-editor .ql-indent-3.ql-direction-rtl.ql-align-right{padding-right:9em}.ql-editor li.ql-indent-3.ql-direction-rtl.ql-align-right{padding-right:10.5em}.ql-editor .ql-indent-4:not(.ql-direction-rtl){padding-left:12em}.ql-editor li.ql-indent-4:not(.ql-direction-rtl){padding-left:13.5em}.ql-editor .ql-indent-4.ql-direction-rtl.ql-align-right{padding-right:12em}.ql-editor li.ql-indent-4.ql-direction-rtl.ql-align-right{padding-right:13.5em}.ql-editor .ql-indent-5:not(.ql-direction-rtl){padding-left:15em}.ql-editor li.ql-indent-5:not(.ql-direction-rtl){padding-left:16.5em}.ql-editor .ql-indent-5.ql-direction-rtl.ql-align-right{padding-right:15em}.ql-editor li.ql-indent-5.ql-direction-rtl.ql-align-right{padding-right:16.5em}.ql-editor .ql-indent-6:not(.ql-direction-rtl){padding-left:18em}.ql-editor li.ql-indent-6:not(.ql-direction-rtl){padding-left:19.5em}.ql-editor .ql-indent-6.ql-direction-rtl.ql-align-right{padding-right:18em}.ql-editor li.ql-indent-6.ql-direction-rtl.ql-align-right{padding-right:19.5em}.ql-editor .ql-indent-7:not(.ql-direction-rtl){padding-left:21em}.ql-editor li.ql-indent-7:not(.ql-direction-rtl){padding-left:22.5em}.ql-editor .ql-indent-7.ql-direction-rtl.ql-align-right{padding-right:21em}.ql-editor li.ql-indent-7.ql-direction-rtl.ql-align-right{padding-right:22.5em}.ql-editor .ql-indent-8:not(.ql-direction-rtl){padding-left:24em}.ql-editor li.ql-indent-8:not(.ql-direction-rtl){padding-left:25.5em}.ql-editor .ql-indent-8.ql-direction-rtl.ql-align-right{padding-right:24em}.ql-editor li.ql-indent-8.ql-direction-rtl.ql-align-right{padding-right:25.5em}.ql-editor .ql-indent-9:not(.ql-direction-rtl){padding-left:27em}.ql-editor li.ql-indent-9:not(.ql-direction-rtl){padding-left:28.5em}.ql-editor .ql-indent-9.ql-direction-rtl.ql-align-right{padding-right:27em}.ql-editor li.ql-indent-9.ql-direction-rtl.ql-align-right{padding-right:28.5em}.ql-editor .ql-video{display:block;max-width:100%}.ql-editor .ql-video.ql-align-center{margin:0 auto}.ql-editor .ql-video.ql-align-right{margin:0 0 0 auto}.ql-editor .ql-bg-black{background-color:#000}.ql-editor .ql-bg-red{background-color:#e60000}.ql-editor .ql-bg-orange{background-color:#f90}.ql-editor .ql-bg-yellow{background-color:#ff0}.ql-editor .ql-bg-green{background-color:#008a00}.ql-editor .ql-bg-blue{background-color:#06c}.ql-editor .ql-bg-purple{background-color:#93f}.ql-editor .ql-color-white{color:#fff}.ql-editor .ql-color-red{color:#e60000}.ql-editor .ql-color-orange{color:#f90}.ql-editor .ql-color-yellow{color:#ff0}.ql-editor .ql-color-green{color:#008a00}.ql-editor .ql-color-blue{color:#06c}.ql-editor .ql-color-purple{color:#93f}.ql-editor .ql-font-serif{font-family:Georgia,Times New Roman,serif}.ql-editor .ql-font-monospace{font-family:Monaco,Courier New,monospace}.ql-editor .ql-size-small{font-size:.75em}.ql-editor .ql-size-large{font-size:1.5em}.ql-editor .ql-size-huge{font-size:2.5em}.ql-editor .ql-direction-rtl{direction:rtl;text-align:inherit}.ql-editor .ql-align-center{text-align:center}.ql-editor .ql-align-justify{text-align:justify}.ql-editor .ql-align-right{text-align:right}.ql-editor.ql-blank::before{color:rgba(0,0,0,.6);content:attr(data-placeholder);font-style:italic;left:15px;pointer-events:none;position:absolute;right:15px}.ql-snow .ql-editor h1{font-size:48px}.ql-snow .ql-editor h2{font-size:40px}.ql-snow .ql-editor h3{font-size:38px}.ql-snow .ql-editor h4{font-size:36px}.ql-snow .ql-editor h5{font-size:.83em}.ql-snow .ql-editor h6{font-size:.67em}.ql-snow .ql-editor a{text-decoration:underline}.ql-snow .ql-editor blockquote{border-left:4px solid #ccc;margin-bottom:5px;margin-top:5px;padding-left:16px}.ql-snow .ql-editor code,.ql-snow .ql-editor pre{background-color:#f0f0f0;border-radius:3px}.ql-snow .ql-editor pre{white-space:pre-wrap;margin-bottom:5px;margin-top:5px;padding:5px 10px}.ql-snow .ql-editor code{font-size:85%;padding:2px 4px}.ql-snow .ql-editor pre.ql-syntax{background-color:#23241f;color:#f8f8f2;overflow:visible}.ql-snow .ql-editor img{max-width:100%}</style></head><body><div class="article"><div class="title">ARTICLE_TITLE</div><div class="ql-snow"><div class="ql-editor">ARTICLE_CONTENT</div></div></div></body></html>';
    return articleHtml
        .replaceAll(new RegExp('ARTICLE_TITLE'), title)
        .replaceAll(new RegExp('ARTICLE_CONTENT'), context);
  }

  _gotoRecordPage(pdf, LearnDetailItem data, result) {
    if (_mIsBack) {
      return;
    }
    MedcloudsNativeApi.instance().record(result.toString());
    MedcloudsNativeApi.instance().addProcessor(
      "uploadLearnVideo",
      (args) async {
        try {
          var obj = json.decode(args);
          CachedVideoInfo info = CachedVideoInfo();
          info.learnPlanId = data.learnPlanId;
          info.resourceId = pdf.resourceId;
          info.videoTitle = obj['title'] ?? data.taskName;
          info.duration = int.parse("${obj['duration'] ?? 0}");
          info.presenter = userInfo?.doctorName ?? '';
          if (Platform.isAndroid) {
            info.path = obj["path"];
          } else {
            String path = obj["path"];
            var prefix = await getApplicationDocumentsDirectory();
            path = path.replaceAll(prefix.path, "");
            info.path = path;
            print("the path is ${path}");
          }
          CachedLearnDetailVideoHelper.cacheVideoInfo(userInfo.doctorUserId,
              CachedLearnDetailVideoHelper.typeLearnVideo, info);
          await _doUpload(info);
        } catch (e) {
          print("e is $e");
          return "网络错误";
        }
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
    var result = await API.shared.server.addLectureSubmit(
      {
        'learnPlanId': data.learnPlanId,
        'resourceId': data.resourceId,
        'videoTitle': data.videoTitle,
        'duration': data.duration,
        'presenter': data.presenter,
        'videoOssId': entity.ossId,
      },
    );
    print("upload finished");
    CachedLearnDetailVideoHelper.cleanVideoCache(
        userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeLearnVideo);
    _model.initData();
    _uploadFinish(result["lectureId"]);
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

  checkVideo() async {
    bool has = await CachedLearnDetailVideoHelper.hasCachedVideo(
        userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeLearnVideo,
        id: widget.learnPlanId);
    var data = await CachedLearnDetailVideoHelper.getCachedVideoInfo(
        userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeLearnVideo);
    setState(() {
      hasVideo = has;
      if (has) {
        videoDuration = data.duration;
      }
    });
  }

  Widget _renderUploadButton(LearnDetailViewModel model, LearnDetailItem data) {
    if (data.taskTemplate == 'DOCTOR_LECTURE' && hasVideo) {
      return Container();
    } else if (data.reLearn && data.taskTemplate == 'DOCTOR_LECTURE') {
      return Container(
        alignment: Alignment.center,
        // margin: EdgeInsets.fromLTRB(20, 10, 20, 40),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 44,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        RouteManagerOld.LOOK_LECTURE_VIDEOS,
                        arguments: {
                          "learnPlanId": data.learnPlanId,
                          "resourceId": data.resources[0].resourceId,
                          'doctorName': userInfo?.doctorName ?? '',
                        });
                  },
                  child: Text(
                    "查看讲课视频",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Color(0xff489DFE),
                    borderRadius: BorderRadius.all(Radius.circular(22))),
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
                  _submit(model, data);
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

  Widget buildDetail(LearnDetailViewModel model) {
    if (model.isBusy) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Container(
          color: ThemeColor.colorFFF3F5F8,
          alignment: Alignment.topCenter,
        ),
      );
    }
    if (model.isError || model.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Container(
          color: ThemeColor.colorFFF3F5F8,
          alignment: Alignment.topCenter,
          child: ViewStateEmptyWidget(onPressed: model.initData),
        ),
      );
    }
    var data = model.data;
    Map dataMap = data.toJson();
    List learnListFields = LEARN_LIST[data.taskTemplate];
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
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                                if ( //data.taskTemplate == 'DOCTOR_LECTURE' &&
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
                                                    color: ThemeColor
                                                        .colorFFfece35,
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
                                                  color:
                                                      ThemeColor.colorFFfece35,
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
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 30, 0),
                                        padding:
                                            EdgeInsets.fromLTRB(0, 14, 0, 0),
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
                                                      textAlign:
                                                          TextAlign.center,
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
                                                          'DEPART' ||
                                                      data.taskTemplate ==
                                                          "PRODUCT_PROFESSIONAL_SHARE" ||
                                                      data.taskTemplate ==
                                                          "PRODUCT_DOCTOR_EDUCATION")
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
                                                      color: ThemeColor
                                                          .primaryColor,
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
                          _renderUploadButton(model, data),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          if (data.taskTemplate == 'DOCTOR_LECTURE' && hasVideo)
            _buildVideoBottom(),
        ],
      ),
    );
  }

  Widget _buildVideoBottom() {
    var second = videoDuration % 60;
    var secondString = second.toString().padLeft(2, '0');
    return Container(
      height: 60,
      color: Color(0xff444444),
      child: Row(
        children: [
          Container(
            width: 18,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "当前有一个未上传的讲课视频",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  "时长${(videoDuration / 60).floor()}:$secondString",
                  style: TextStyle(color: Color(0xff489DFE), fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              _showUploadVideoAlert(
                "确定删除已录制的讲课视频吗？",
                "录制时长${(videoDuration / 60).floor()}:$secondString",
                () {
                  CachedLearnDetailVideoHelper.cleanVideoCache(
                      userInfo.doctorUserId,
                      CachedLearnDetailVideoHelper.typeLearnVideo);
                  setState(() {
                    hasVideo = false;
                  });
                },
              );
            },
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "删除",
                style: TextStyle(color: Color(0xffFECE35), fontSize: 12),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              EasyLoading.instance.flash(() async {
                var data =
                    await CachedLearnDetailVideoHelper.getCachedVideoInfo(
                        userInfo.doctorUserId,
                      CachedLearnDetailVideoHelper.typeLearnVideo);
                await _doUpload(data);
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "重新上传",
                style: TextStyle(color: Color(0xff489DFE), fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _mIsBack = false;

  updateCheck(LearnDetailViewModel model, dynamic learnPlanId) async {
    var status = model.data?.status;
    if (status == 'SUBMIT_LEARN' || status == 'ACCEPTED') {
      var has = await CachedLearnDetailVideoHelper.hasCachedVideo(
          userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeLearnVideo,
          id: learnPlanId);
      if (has) {
        CachedLearnDetailVideoHelper.cleanVideoCache(
            userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeLearnVideo);
      }
    }
    checkVideo();
  }

  @override
  Widget build(BuildContext context) {
    if (_model == null) {
      _model = LearnDetailViewModel(widget.learnPlanId);
    }
    return WillPopScope(
        child: ProviderWidget<LearnDetailViewModel>(
          model: _model,
          onModelReady: (model) => model.initData(),
          builder: (context, model, child) {
            if (model.data?.taskTemplate == 'MEDICAL_SURVEY') {
              return ResearchDetail();
            } else {
              updateCheck(model, widget.learnPlanId);
              return buildDetail(model);
            }
          },
        ),
        onWillPop: () {
          EasyLoading.dismiss();
          return Future.value(_mIsBack = true);
        });
  }
}
