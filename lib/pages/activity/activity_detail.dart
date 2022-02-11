import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:doctor/http/common_service.dart';
import 'package:doctor/http/oss_service.dart';
import 'package:doctor/model/ucenter/doctor_detail_info_entity.dart';
import 'package:doctor/pages/activity/activity_case_detail.dart';
import 'package:doctor/pages/activity/activity_research.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/pages/activity/widget/activity_resource_detail.dart';
import 'package:doctor/pages/user/ucenter_view_model.dart';
import 'package:doctor/pages/worktop/learn/cache_learn_detail_video_helper.dart';
import 'package:doctor/pages/worktop/learn/lecture_videos/look_activity_lecture_video_page.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/root_widget.all.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/data_format_util.dart';
import 'package:doctor/utils/platform_utils.dart';
import 'package:doctor/utils/time_text.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:doctor/http/activity.dart';
import "package:dio/dio.dart";
import 'package:yyy_route_annotation/yyy_route_annotation.dart';

import 'activity_constants.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/server.dart';

@RoutePage(needLogin: true, needAuth: true, name: "activity_detail_page")
class ActivityDetail extends StatefulWidget {
  final int activityPackageId;
  final String type;

  ActivityDetail(this.activityPackageId, this.type);

  @override
  State<StatefulWidget> createState() {
    return _ActivityState();
  }
}

class _ActivityState extends State<ActivityDetail> {
  bool showInfo = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  DoctorDetailInfoEntity userInfo;
  ActivityDetailEntity _data;
  List _list = [];
  bool _isLoading = true;
  String _error;
  int _page = 1;

  @override
  void initState() {
    firstGetData();
    super.initState();
  }

  updateDoctorInfo() async {
    UserInfoViewModel model =
        Provider.of<UserInfoViewModel>(context, listen: false);
    if (model?.data != null) {
      await model.queryDoctorInfo();
      userInfo = model.data;
    }
  }

  firstGetData() async {
    try {
      await updateDoctorInfo();
      var result =
          await API.shared.activity.packageDetail(widget.activityPackageId);
      _data = ActivityDetailEntity(result);
      if (_data.activityType == TYPE_LECTURE_VIDEO)
        updateCheck(_data, widget.activityPackageId);
      print('------------------${widget.activityPackageId}');
      var rawData = await API.shared.activity
          .activityTaskList(widget.activityPackageId, 1);
      var list = rawData["records"];
      var allPage = rawData["pages"] as int;
      _page = 1;
      if (allPage == _page) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
      _list = list;
    } on DioError catch (e) {
      setState(() {
        _error = "${e.message}";
      });
    } catch (e) {
      setState(() {
        _error = "${e}";
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void loadMoreData() async {
    _page++;
    var rawData = await API.shared.activity
        .activityTaskList(widget.activityPackageId, _page);
    List list = rawData["records"];
    var allPage = rawData["pages"] as int;
    print("all page is - $allPage");
    if (allPage == _page) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
    setState(() {
      _list.addAll(list);
    });
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

  _getHTML(title, context) {
    String articleHtml =
        r'<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><meta name="renderer" content="webkit"><meta name="force-rendering" content="webkit"><meta name="viewport" content="initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no"><style>body{margin:0;background:#f3f5f8;padding:16px 16px 60px}.article{padding:14px 16px 16px;background:#fff;border-radius:8px}.title{color:#222;font-size:16px;text-align:center;font-weight:500;margin-bottom:12px}.ql-editor blockquote,.ql-editor h1,.ql-editor h2,.ql-editor h3,.ql-editor h4,.ql-editor h5,.ql-editor h6,.ql-editor ol,.ql-editor p,.ql-editor pre,.ql-editor ul{margin:0;padding:0;counter-reset:list-1 list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor ol,.ql-editor ul{padding-left:1.5em}.ql-editor ol>li,.ql-editor ul>li{list-style-type:none}.ql-editor ul>li::before{content:"\2022"}.ql-editor ul[data-checked=false],.ql-editor ul[data-checked=true]{pointer-events:none}.ql-editor ul[data-checked=false]>li *,.ql-editor ul[data-checked=true]>li *{pointer-events:all}.ql-editor ul[data-checked=false]>li::before,.ql-editor ul[data-checked=true]>li::before{color:#777;cursor:pointer;pointer-events:all}.ql-editor ul[data-checked=true]>li::before{content:"\2611"}.ql-editor ul[data-checked=false]>li::before{content:"\2610"}.ql-editor li::before{display:inline-block;white-space:nowrap;width:1.2em}.ql-editor li:not(.ql-direction-rtl)::before{margin-left:-1.5em;margin-right:.3em;text-align:right}.ql-editor li.ql-direction-rtl::before{margin-left:.3em;margin-right:-1.5em}.ql-editor ol li:not(.ql-direction-rtl),.ql-editor ul li:not(.ql-direction-rtl){padding-left:1.5em}.ql-editor ol li.ql-direction-rtl,.ql-editor ul li.ql-direction-rtl{padding-right:1.5em}.ql-editor ol li{counter-reset:list-1 list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9;counter-increment:list-0}.ql-editor ol li:before{content:counter(list-0,decimal) ". "}.ql-editor ol li.ql-indent-1{counter-increment:list-1}.ql-editor ol li.ql-indent-1:before{content:counter(list-1,lower-alpha) ". "}.ql-editor ol li.ql-indent-1{counter-reset:list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-2{counter-increment:list-2}.ql-editor ol li.ql-indent-2:before{content:counter(list-2,lower-roman) ". "}.ql-editor ol li.ql-indent-2{counter-reset:list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-3{counter-increment:list-3}.ql-editor ol li.ql-indent-3:before{content:counter(list-3,decimal) ". "}.ql-editor ol li.ql-indent-3{counter-reset:list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-4{counter-increment:list-4}.ql-editor ol li.ql-indent-4:before{content:counter(list-4,lower-alpha) ". "}.ql-editor ol li.ql-indent-4{counter-reset:list-5 list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-5{counter-increment:list-5}.ql-editor ol li.ql-indent-5:before{content:counter(list-5,lower-roman) ". "}.ql-editor ol li.ql-indent-5{counter-reset:list-6 list-7 list-8 list-9}.ql-editor ol li.ql-indent-6{counter-increment:list-6}.ql-editor ol li.ql-indent-6:before{content:counter(list-6,decimal) ". "}.ql-editor ol li.ql-indent-6{counter-reset:list-7 list-8 list-9}.ql-editor ol li.ql-indent-7{counter-increment:list-7}.ql-editor ol li.ql-indent-7:before{content:counter(list-7,lower-alpha) ". "}.ql-editor ol li.ql-indent-7{counter-reset:list-8 list-9}.ql-editor ol li.ql-indent-8{counter-increment:list-8}.ql-editor ol li.ql-indent-8:before{content:counter(list-8,lower-roman) ". "}.ql-editor ol li.ql-indent-8{counter-reset:list-9}.ql-editor ol li.ql-indent-9{counter-increment:list-9}.ql-editor ol li.ql-indent-9:before{content:counter(list-9,decimal) ". "}.ql-editor .ql-indent-1:not(.ql-direction-rtl){padding-left:3em}.ql-editor li.ql-indent-1:not(.ql-direction-rtl){padding-left:4.5em}.ql-editor .ql-indent-1.ql-direction-rtl.ql-align-right{padding-right:3em}.ql-editor li.ql-indent-1.ql-direction-rtl.ql-align-right{padding-right:4.5em}.ql-editor .ql-indent-2:not(.ql-direction-rtl){padding-left:6em}.ql-editor li.ql-indent-2:not(.ql-direction-rtl){padding-left:7.5em}.ql-editor .ql-indent-2.ql-direction-rtl.ql-align-right{padding-right:6em}.ql-editor li.ql-indent-2.ql-direction-rtl.ql-align-right{padding-right:7.5em}.ql-editor .ql-indent-3:not(.ql-direction-rtl){padding-left:9em}.ql-editor li.ql-indent-3:not(.ql-direction-rtl){padding-left:10.5em}.ql-editor .ql-indent-3.ql-direction-rtl.ql-align-right{padding-right:9em}.ql-editor li.ql-indent-3.ql-direction-rtl.ql-align-right{padding-right:10.5em}.ql-editor .ql-indent-4:not(.ql-direction-rtl){padding-left:12em}.ql-editor li.ql-indent-4:not(.ql-direction-rtl){padding-left:13.5em}.ql-editor .ql-indent-4.ql-direction-rtl.ql-align-right{padding-right:12em}.ql-editor li.ql-indent-4.ql-direction-rtl.ql-align-right{padding-right:13.5em}.ql-editor .ql-indent-5:not(.ql-direction-rtl){padding-left:15em}.ql-editor li.ql-indent-5:not(.ql-direction-rtl){padding-left:16.5em}.ql-editor .ql-indent-5.ql-direction-rtl.ql-align-right{padding-right:15em}.ql-editor li.ql-indent-5.ql-direction-rtl.ql-align-right{padding-right:16.5em}.ql-editor .ql-indent-6:not(.ql-direction-rtl){padding-left:18em}.ql-editor li.ql-indent-6:not(.ql-direction-rtl){padding-left:19.5em}.ql-editor .ql-indent-6.ql-direction-rtl.ql-align-right{padding-right:18em}.ql-editor li.ql-indent-6.ql-direction-rtl.ql-align-right{padding-right:19.5em}.ql-editor .ql-indent-7:not(.ql-direction-rtl){padding-left:21em}.ql-editor li.ql-indent-7:not(.ql-direction-rtl){padding-left:22.5em}.ql-editor .ql-indent-7.ql-direction-rtl.ql-align-right{padding-right:21em}.ql-editor li.ql-indent-7.ql-direction-rtl.ql-align-right{padding-right:22.5em}.ql-editor .ql-indent-8:not(.ql-direction-rtl){padding-left:24em}.ql-editor li.ql-indent-8:not(.ql-direction-rtl){padding-left:25.5em}.ql-editor .ql-indent-8.ql-direction-rtl.ql-align-right{padding-right:24em}.ql-editor li.ql-indent-8.ql-direction-rtl.ql-align-right{padding-right:25.5em}.ql-editor .ql-indent-9:not(.ql-direction-rtl){padding-left:27em}.ql-editor li.ql-indent-9:not(.ql-direction-rtl){padding-left:28.5em}.ql-editor .ql-indent-9.ql-direction-rtl.ql-align-right{padding-right:27em}.ql-editor li.ql-indent-9.ql-direction-rtl.ql-align-right{padding-right:28.5em}.ql-editor .ql-video{display:block;max-width:100%}.ql-editor .ql-video.ql-align-center{margin:0 auto}.ql-editor .ql-video.ql-align-right{margin:0 0 0 auto}.ql-editor .ql-bg-black{background-color:#000}.ql-editor .ql-bg-red{background-color:#e60000}.ql-editor .ql-bg-orange{background-color:#f90}.ql-editor .ql-bg-yellow{background-color:#ff0}.ql-editor .ql-bg-green{background-color:#008a00}.ql-editor .ql-bg-blue{background-color:#06c}.ql-editor .ql-bg-purple{background-color:#93f}.ql-editor .ql-color-white{color:#fff}.ql-editor .ql-color-red{color:#e60000}.ql-editor .ql-color-orange{color:#f90}.ql-editor .ql-color-yellow{color:#ff0}.ql-editor .ql-color-green{color:#008a00}.ql-editor .ql-color-blue{color:#06c}.ql-editor .ql-color-purple{color:#93f}.ql-editor .ql-font-serif{font-family:Georgia,Times New Roman,serif}.ql-editor .ql-font-monospace{font-family:Monaco,Courier New,monospace}.ql-editor .ql-size-small{font-size:.75em}.ql-editor .ql-size-large{font-size:1.5em}.ql-editor .ql-size-huge{font-size:2.5em}.ql-editor .ql-direction-rtl{direction:rtl;text-align:inherit}.ql-editor .ql-align-center{text-align:center}.ql-editor .ql-align-justify{text-align:justify}.ql-editor .ql-align-right{text-align:right}.ql-editor.ql-blank::before{color:rgba(0,0,0,.6);content:attr(data-placeholder);font-style:italic;left:15px;pointer-events:none;position:absolute;right:15px}.ql-snow .ql-editor h1{font-size:48px}.ql-snow .ql-editor h2{font-size:40px}.ql-snow .ql-editor h3{font-size:38px}.ql-snow .ql-editor h4{font-size:36px}.ql-snow .ql-editor h5{font-size:.83em}.ql-snow .ql-editor h6{font-size:.67em}.ql-snow .ql-editor a{text-decoration:underline}.ql-snow .ql-editor blockquote{border-left:4px solid #ccc;margin-bottom:5px;margin-top:5px;padding-left:16px}.ql-snow .ql-editor code,.ql-snow .ql-editor pre{background-color:#f0f0f0;border-radius:3px}.ql-snow .ql-editor pre{white-space:pre-wrap;margin-bottom:5px;margin-top:5px;padding:5px 10px}.ql-snow .ql-editor code{font-size:85%;padding:2px 4px}.ql-snow .ql-editor pre.ql-syntax{background-color:#23241f;color:#f8f8f2;overflow:visible}.ql-snow .ql-editor img{max-width:100%}</style></head><body><div class="article"><div class="title">ARTICLE_TITLE</div><div class="ql-snow"><div class="ql-editor">ARTICLE_CONTENT</div></div></div></body></html>';
    return articleHtml
        .replaceAll(new RegExp('ARTICLE_TITLE'), title)
        .replaceAll(new RegExp('ARTICLE_CONTENT'), context);
  }

  bool _canSend = true;

  _gotoRecordPage(result) {
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
        'activityPackageId': _data.activityPackageId,
        'activityTaskId': data.resourceId,
        'name': data.videoTitle,
        'duration': data.duration,
        'presenter': data.presenter,
        'ossId': entity.ossId,
      },
    );
    print("upload finished");
    CachedLearnDetailVideoHelper.cleanVideoCache(
        userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeActivityVideo);
    await firstGetData();
  }

  _gotoRecord() async {
    if (EasyLoading.isShow) {
      return;
    }
    var videoData = await CachedLearnDetailVideoHelper.getCachedVideoInfo(
        userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeActivityVideo);
    if (videoData != null) {
      _showUploadVideoAlert(
        "您暂时无法录制新的讲课视频",
        "您有一个未完成的讲课邀请任务是否立即查看详情",
        () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ActivityDetail(videoData.learnPlanId, TYPE_LECTURE_VIDEO);
          }));
        },
        cancel: "暂不查看",
        done: "查看详情",
      );
      return;
    }
    await _gogogogogogo();
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

  Widget cardTitle(String data) {
    return Text(
      data,
      style: TextStyle(
        color: Color(0xff107BFD),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget card({@required Widget child}) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 12),
      padding: EdgeInsets.symmetric(vertical: 21, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: child,
    );
  }

  Widget buildInfo() {
    Widget line(String title, String desc) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xff005aa0).withOpacity(0.1)),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff444444),
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 5),
            ),
            Expanded(
              child: Text(
                desc,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> showLine() {
      if (showInfo) {
        return [
          line("活动名称", _data.activityName),
          line("来自企业", _data.companyName),
          line("截止日期", "${normalFullDateFormate(_data.endTime)}"),
        ];
      }
      return [];
    }

    Color _statusColor(String status, bool disable) {
      if (disable) {
        return ThemeColor.colorFFD9D5D5;
      }
      if (status == STATUS_WAIT) {
        return ThemeColor.primaryColor;
      } else if (status == STATUS_EXECUTING) {
        return Color(0xFF5AC624);
      } else {
        return ThemeColor.colorFFD9D5D5;
      }
    }

    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cardTitle("${activityName(widget.type)}信息"),
              LearnTextIcon(
                  text: activityStatus(_data.status, _data.disable),
                  color: _statusColor(_data.status, _data.disable),
                  margin: EdgeInsets.only(left: 10)),
              Expanded(child: Container()),
              IconButton(
                icon: showInfo
                    ? Icon(Icons.arrow_drop_up)
                    : Icon(Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    showInfo = !showInfo;
                  });
                },
              ),
            ],
          ),
          ...showLine(),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "当前完成度：${_data.schedule}%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff107bfd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDesc() {
    if (_data.activityContent == null) {
      return Container();
    }
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cardTitle("${activityName(widget.type)}说明"),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 12),
          ),
          Text(
            _data.activityContent ?? "",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xff222222),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    Widget line(String desc, String status, int schedule, int taskId,
        String rejectReason) {
      Color color = Color(0xff444444);
      String text = "";
      print("$status --  status is ");
      if (status == "INVALID") {
        text = "已作废";
      } else if (schedule != null && schedule < 100) {
        text = "完成度$schedule%";
      } else if (status == "WAIT_VERIFY") {
        text = "待审核";
      } else if (status == "REJECT") {
        color = Color(0xffFAAD14);
        text = "审核未通过";
      } else if (status == "COMPLETE") {
        color = Color(0xff52C41A);
        text = "审核通过";
      }
      var content = Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Color(0xffe5e5f5),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                desc,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff444444),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 5)),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      );
      return GestureDetector(
        child: content,
        onTap: () async {
          if (status == "INVALID") {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text("作废理由"),
                    content: Text(rejectReason),
                    actions: [
                      TextButton(
                        child: Text("知道了"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
            return;
          } else if (_data.activityType == TYPE_CASE_COLLECTION) {
            await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
              return ActivityResourceDetailPage(
                _data.activityPackageId,
                taskId,
                status: status,
                rejectReason: rejectReason,
              );
            }));
          } else if (_data.activityType == TYPE_LECTURE_VIDEO) {
            RouteManager.push(context, RoutMapping.look_lecture_videos_page(_data.activityPackageId, taskId));
            // Navigator.of(context).push(MaterialPageRoute(builder: (c) {
            //   return LookLectureVideosPage(_data.activityTaskId,taskId);
            // }));
          } else {
            await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
              return ActivityResearch(
                _data.activityPackageId,
                activityTaskId: taskId,
              );
            }));
          }
          firstGetData();
        },
      );
    }

    List<Widget> lines = [];
    for (int i = 0; i < _list.length; i++) {
      var item = _list[i];
      String desc = "";
      if (widget.type == TYPE_CASE_COLLECTION) {
        desc = "病例${i + 1}:已上传${item["pictureNum"]}张图片";
      } else if (widget.type == TYPE_LECTURE_VIDEO) {
        desc = "${item["activityTaskName"]}";
      } else {
        Map<String, dynamic> illnessCase = item["illnessCase"];
        desc = "病例${i + 1}:";
        var needLine = false;
        if (illnessCase["patientName"] != null &&
            (illnessCase["patientName"] as String).length > 0) {
          desc += "${illnessCase["patientName"]}";
          needLine = true;
        }

        if (illnessCase["age"] != null) {
          if (needLine) {
            desc += "|";
          }
          desc += "${illnessCase["age"]}";
          needLine = true;
        }

        if (illnessCase["sex"] != null) {
          if (needLine) {
            desc += "|";
          }
          var name = "";
          if (illnessCase["sex"] == 0) {
            name = "女";
            desc += "$name";
          } else if (illnessCase["sex"] == 1) {
            name = "男";
            desc += "$name";
          }
        }
      }
      var itemWidget = line(desc, item["status"], item["schedule"],
          item["activityTaskId"], item["rejectReason"]);
      lines.add(itemWidget);
    }

    if (_list.length == 0) {
      return Container();
    }
    var title = "病例列表";
    if (_data.activityType == TYPE_MEDICAL_SURVEY) {
      title = "调研列表";
    } else if (_data.activityType == TYPE_LECTURE_VIDEO) {
      title = "讲课视频列表";
    }
    return card(
      child: Column(
        children: [
          Row(
            children: [
              cardTitle(title),
            ],
          ),
          ...lines,
        ],
      ),
    );
  }

  Widget buildBody() {
    List<Widget> bottoms = [];
    List<Widget> headers = [];
    if (_data.disable == true) {
      headers = [
        Container(
          height: 50,
          color: Color(0xfff8cc76),
          alignment: Alignment.center,
          child: Text(
            _data.reason,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        )
      ];
      bottoms = [
        Container(
          padding: EdgeInsets.only(bottom: 53),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 33),
            alignment: Alignment.center,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xff888888),
              borderRadius: BorderRadius.all(Radius.circular(22)),
            ),
            child: Text(
              "活动已结束",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        )
      ];
    } else if (_data.status == "WAIT_START") {
      bottoms = [
        Container(
          padding: EdgeInsets.only(bottom: 53),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 33),
            alignment: Alignment.center,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xff888888),
              borderRadius: BorderRadius.all(Radius.circular(22)),
            ),
            child: Text(
              "活动于${normalDateFormate(_data.startTime)}开始",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        )
      ];
    } else if (_data.status == "EXECUTING") {
      var last = "";
      var title = "";
      if (widget.type == TYPE_CASE_COLLECTION) {
        last = "剩余病例数";
        title = "填写病例信息";
      } else if (widget.type == TYPE_MEDICAL_SURVEY) {
        last = "剩余调研数";
        title = "填写医学调研";
      } else if (widget.type == TYPE_LECTURE_VIDEO) {
        last = "剩余讲课视频数";
        title = "录制讲课视频";
      } else {
        last = "剩余调研数";
        title = "填写RWS";
      }
      bottoms = [
        if (widget.type == TYPE_MEDICAL_SURVEY || widget.type == TYPE_LECTURE_VIDEO)
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "$last${_data.waitExecuteTask}",
              style: TextStyle(
                color: Color(0xff107BFD),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.only(bottom: 53),
          child: AceButton(
            text: title,
            onPressed: () async {
              if (_data.waitExecuteTask <= 0) {
                EasyLoading.showToast("没有剩余调研数");
                return;
              }
              if (_data.activityType == TYPE_CASE_COLLECTION) {
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) {
                  return ActivityResourceDetailPage(
                      _data.activityPackageId, null);
                }));
              } else if (widget.type == TYPE_LECTURE_VIDEO) {
                _gotoRecord();
              } else {
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ActivityResearch(_data.activityPackageId);
                }));
              }
              firstGetData();
            },
          ),
        )
      ];
    } else {
      bottoms = [
        Container(
          padding: EdgeInsets.only(bottom: 53),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 33),
            alignment: Alignment.center,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xff888888),
              borderRadius: BorderRadius.all(Radius.circular(22)),
            ),
            child: Text(
              "活动已结束",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        )
      ];
    }
    return Column(
      children: [
        Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            header: ClassicHeader(),
            footer: ClassicFooter(),
            enablePullDown: false,
            enablePullUp: _list.length > 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...headers,
                  buildInfo(),
                  buildDesc(),
                  buildList(),
                ],
              ),
            ),
            onLoading: () async {
              loadMoreData();
            },
          ),
        ),
        if (!hasVideo) ...bottoms,
        _buildVideoBottom(),
      ],
    );
  }

  bool hasVideo = false;
  int videoDuration = 0;

  checkVideo() async {
    bool has = await CachedLearnDetailVideoHelper.hasCachedVideo(
        userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeActivityVideo,
        id: widget.activityPackageId);
    var data = await CachedLearnDetailVideoHelper.getCachedVideoInfo(
        userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeActivityVideo);
    setState(() {
      hasVideo = has;
      if (has) {
        videoDuration = data.duration;
      }
    });
  }

  updateCheck(ActivityDetailEntity entity, dynamic learnPlanId) async {
    // if (entity.status == "VERIFYED") {
    //   var has = await CachedLearnDetailVideoHelper.hasCachedVideo(
    //       userInfo.doctorUserId, CachedLearnDetailVideoHelper.typeActivityVideo,
    //       id: learnPlanId);
    //   if (has) {
    //     CachedLearnDetailVideoHelper.cleanVideoCache(userInfo.doctorUserId,
    //         CachedLearnDetailVideoHelper.typeActivityVideo);
    //   }
    // }
    checkVideo();
  }

  Widget _buildVideoBottom() {
    if (!hasVideo) {
      return Container();
    }
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
                      CachedLearnDetailVideoHelper.typeActivityVideo);
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
                        CachedLearnDetailVideoHelper.typeActivityVideo);
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

  Widget _showHolder() {
    var child = ViewStateEmptyWidget(
      message: "$_error",
    );

    return Center(
      child: TextButton(
        child: child,
        onPressed: () {
          _error = null;
          setState(() {
            _isLoading = true;
          });
          firstGetData();
        },
      ),
    );
  }

  Widget loading() {
    return Container(
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Theme(
            data: ThemeData(
                cupertinoOverrideTheme: CupertinoThemeData(
              brightness: Brightness.dark,
            )),
            child: CupertinoActivityIndicator(
              radius: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget realBody() {
    if (_isLoading) {
      return loading();
    } else if (_error != null) {
      return _showHolder();
    } else {
      return buildBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F5F8),
      appBar: AppBar(
        title: Text("${activityName(widget.type)}活动"),
      ),
      body: WillPopScope(
        child: realBody(),
        onWillPop: () async {
          firstGetData();
          return true;
        },
      ),
    );
  }
}
