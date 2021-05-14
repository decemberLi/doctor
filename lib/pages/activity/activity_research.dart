import 'package:doctor/provider/provider_widget.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/utils/data_format_util.dart';
import 'package:doctor/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:doctor/common/env/environment.dart';
import 'package:doctor/common/env/url_provider.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/learn/research_detail/case_detail.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/time_text.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/activity.dart';
import 'package:dio/dio.dart';

import 'activity_case_detail.dart';
import 'entity/activity_entity.dart';
import 'entity/activity_questionnaire_entity.dart';

class ActivityResearch extends StatefulWidget {
  final int activityPackageId;
  final int activityTaskId;

  ActivityResearch(this.activityPackageId, {this.activityTaskId});

  @override
  State<StatefulWidget> createState() {
    return _ActivityResearch(activityTaskId);
  }
}

class _ActivityResearch extends State<ActivityResearch>
    with WidgetsBindingObserver {
  bool collapsed = true;
  int activityTaskId;
  String status;

  _ActivityResearch(this.activityTaskId);

  // LearnDetailViewModel _model = LearnDetailViewModel(137574);
  ActivityQuestionnaireEntity _data;
  String error;
  bool _loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    freshData();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      freshData();
    }
  }

  void freshData() async {
    _loading = true;
    try {
      var result =
          await API.shared.activity.packageDetail(widget.activityPackageId);
      var parentData = ActivityDetailEntity(result);
      status = parentData.status;
      Map<String, dynamic> json = await API.shared.activity
          .activityQuestionnaireList(widget.activityPackageId,
              activityTaskId: activityTaskId);
      _data = ActivityQuestionnaireEntity.fromJson(json);
      error = null;
      setState(() {});
    } on DioError catch (e) {
      error = e.message;
      setState(() {});
    } catch (e) {
      error = "$e";
      setState(() {});
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget item(Widget content) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: content,
    );
  }

  Widget plans(ActivityQuestionnaireEntity data) {
    var template = data;
    if (template == null || template.questionnaires == null) return Container();
    List<Widget> sources = [];
    for (int i = 0; i < template.questionnaires.length; i++) {
      var item = template.questionnaires[i];
      var cell = buildPlanItem(
          template.resourceId, item, i == template.questionnaires.length - 1);
      sources.add(cell);
    }

    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                '执行医学调研',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF107BFD),
                ),
              ),
            ),
            buildCaseItem(template.illnessCase),
            ...sources,
          ],
        ),
      ),
    );
  }

  Widget buildCaseItem(ActivityIllnessCaseEntity item) {
    var buttonText = "点击此处去填写";
    var statusText = "待完成";
    var statusColor = Color(0xff489DFE);
    var borderColor = Color(0xff888888);
    var canEdit = _data.activityTaskId == null;
    var itemCanEdit = true;
    _data.questionnaires.forEach((element) {
      print("the status is - ${element.status}");
      itemCanEdit = itemCanEdit &&
          (element.status == "NOT_OPEN" ||
              element.status == "PROCEEDING" ||
              element.status == null);
    });
    canEdit = canEdit || itemCanEdit;
    print("can edit is --- $canEdit");
    if (!canEdit) {
      buttonText = "查看病例信息";
      statusText = "已完成";
      statusColor = Color(0xff52C41A);
      borderColor = Color(0xff52C41A);
    } else if (item.status == "COMPLETE") {
      buttonText = "点击此处去重新编辑";
      statusText = "已完成";
      statusColor = Color(0xff52C41A);
      borderColor = Color(0xff52C41A);
    }
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  "${item.schedule}%",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: borderColor,
                  ),
                ),
              ),
              Text(
                "填写病例信息",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 7),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(25, 5, 0, 20),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: borderColor,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () async {
                var taskId = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ActivityCaseDetail(
                    item,
                    widget.activityPackageId,
                    canEdit,
                    activityTaskId: activityTaskId,
                  ),
                ));
                if (taskId != null) {
                  activityTaskId = taskId;
                }
                freshData();
              },
              child: Container(
                margin: EdgeInsets.only(top: 12),
                alignment: Alignment.center,
                height: 30,
                width: double.infinity,
                decoration: DashedDecoration(dashedColor: Color(0xff9BCDF4)),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff489DFE),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlanItem(
      int resourceID, ActivityQuestionnairesSubEntity item, bool isEnd) {
    ActivityQuestionnaireEntity data = _data;
    var timeText = "";
    if (item.openTime != null) {
      timeText = "${normalDateFormate(item.openTime)}开启填写";
    }
    var statusText = "未开启";
    var statusColor = Color(0xffDEDEE1);
    var borderColor = Color(0xff888888);
    if (item.status == "PROCEEDING" || item.status == "REJECT") {
      timeText = "";
      statusText = "待完成";
      statusColor = Color(0xff489DFE);
      borderColor = Color(0xff888888);
    } else if (item.status == "COMPLETE" || item.status == "WAIT_VERIFY") {
      timeText = "${normalDateFormate(item.submitTime)}完成";
      statusText = "已完成";
      statusColor = Color(0xff52C41A);
      borderColor = Color(0xff52C41A);
    }
    var statusWidget = Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 7),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );

    var content = Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(26, 15, 15, 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xfff8f8f8),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item.title}",
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: 14,
                ),
              ),
              Text(
                item.summary,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff444444),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: -52,
          top: -28,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Transform(
              //对齐方式
              alignment: Alignment.topRight,
              //设置扭转值
              transform: Matrix4.rotationZ(-0.9),
              //设置被旋转的容器
              child: typeDecoratedBox("MEDICAL_TEMPLATE"),
            ),
          ),
        ),
      ],
    );
    var bottom = Column(
      children: [
        if (item.rejectReason != null)
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "驳回理由:${item.rejectReason}",
              style: TextStyle(
                color: Color(0xffFECE35),
                fontSize: 12,
              ),
            ),
          ),
        content,
      ],
    );
    var all = Container(
      margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  "${item.schedule}%",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: borderColor,
                  ),
                ),
              ),
              Text(
                "填写问卷${item.sort}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              statusWidget,
              Expanded(child: Container()),
              Text(
                timeText,
                style: TextStyle(
                  color: Color(0xff888888),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(25, 5, 0, 20),
            decoration: isEnd
                ? null
                : BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: borderColor,
                      ),
                    ),
                  ),
            child: bottom,
          ),
        ],
      ),
    );
    return GestureDetector(
      onTap: debounce(() {
        if (status == "END" &&
            (item.status == "NOT_OPEN" ||
                item.status == "PROCEEDING" ||
                item.status == "WAIT_VERIFY")) {
          EasyLoading.showToast("活动已过期，无法开启此问卷");
          return;
        }
        var url =
            "${UrlProvider.mHost(Environment.instance)}mpost/#/questionnaire?activityPackageId=${data.activityPackageId}&resourceId=$resourceID&questionnaireId=${item.questionnaireId}&sort=${item.sort}&type=market&packageStatus=${status}&activityTaskId=${activityTaskId}";
        MedcloudsNativeApi.instance().openWebPage(url);
      }),
      child: all,
    );
  }

  Widget typeDecoratedBox(String type) {
    Color rendColor = Color(0xffFAAD14);
    return DecoratedBox(
      decoration: BoxDecoration(color: rendColor),
      child: Padding(
        // 分别指定四个方向的补白
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Text(
          MAP_RESOURCE_TYPE[type],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget card({@required Widget child}) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 64),
      padding: EdgeInsets.symmetric(vertical: 21, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: child,
    );
  }

  Widget buildContent() {
    if (_loading) {
      return loading();
    } else if (error != null) {
      return ViewStateEmptyWidget(
        message: error,
      );
    } else if (_data == null) {
      return Container();
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          plans(_data),
          Container(
            height: 20,
          )
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F5F8),
      appBar: AppBar(
        title: Text("医学调研详情"),
      ),
      body: buildContent(),
    );
  }
}
