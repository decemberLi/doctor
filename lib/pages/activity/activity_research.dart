import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/utils/data_format_util.dart';
import 'package:doctor/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:doctor/common/env/environment.dart';
import 'package:doctor/common/env/url_provider.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:doctor/http/activity.dart';
import 'package:dio/dio.dart';
import 'package:yyy_route_annotation/yyy_route_annotation.dart';

import 'activity_case_detail.dart';
import 'activity_constants.dart';
import 'entity/activity_entity.dart';
import 'entity/activity_questionnaire_entity.dart';

@RoutePage(name: "medical_survey_page")
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
  String activetyType = "";
  bool disable = false;

  _ActivityResearch(this.activityTaskId);

  // LearnDetailViewModel _model = LearnDetailViewModel(137574);
  ActivityQuestionnaireEntity _data;
  String error;
  bool _loading = true;
  Set<int> expandedGroup = Set();

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
      disable = parentData.disable;
      activetyType = parentData.activityType;
      Map<String, dynamic> json = await API.shared.activity
          .activityQuestionnaireList(widget.activityPackageId,
              activityTaskId: activityTaskId);
      _data = ActivityQuestionnaireEntity.fromJson(json);
      error = null;
      expandedGroup.clear();
      if (_data.questionnaireGroups != null) {
        _data.questionnaireGroups.forEach((element) {
          if (element.status == "PROCEEDING") {
            expandedGroup.add(element.groupId);
          }
        });
      }
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
    print("the data is not null plans ${data.contentType}");
    var template = data;
    if (template == null) return Container();
    List<Widget> sources = [];
    if (template.contentType == "QUESTIONNAIRE_GROUP") {
      print("show group item");
      if (template.questionnaireGroups == null) {
        return Container();
      }
      for (int i = 0; i < template.questionnaireGroups.length; i++) {
        var item = template.questionnaireGroups[i];
        var cell = buildGroupItem(template.resourceId, item,
            i == template.questionnaireGroups.length - 1, i == 0);
        sources.add(cell);
      }
    } else {
      if (template.questionnaires == null) {
        return Container();
      }
      for (int i = 0; i < template.questionnaires.length; i++) {
        var item = template.questionnaires[i];
        var cell = buildPlanItem(template.resourceId, item,
            i == template.questionnaires.length - 1, i == 0);
        sources.add(cell);
      }
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
                '??????${activityName(activetyType)}',
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
    var buttonText = "?????????????????????";
    var statusText = "?????????";
    var statusColor = Color(0xff489DFE);
    var borderColor = Color(0xffaaaaaa);
    var img = "assets/images/progress.png";
    var canEdit = _data.activityTaskId == null || _data.updatePatient;
    print("can edit is --- $canEdit");
    if (!canEdit) {
      buttonText = "??????????????????";
      statusText = "?????????";
      statusColor = Color(0xff52C41A);
      borderColor = Color(0xff52C41A);
      img = "assets/images/complete.png";
    } else if (item.status == "COMPLETE") {
      buttonText = "???????????????????????????";
      statusText = "?????????";
      statusColor = Color(0xff52C41A);
      borderColor = Color(0xff52C41A);
      img = "assets/images/complete.png";
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
                    color: borderColor,
                  ),
                ),
              ),
              Text(
                "??????????????????",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 7),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Row(
                    children: [
                      Image.asset(img),
                      Padding(padding: EdgeInsets.only(right: 4)),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )),
              Spacer(),
              canEdit
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ActivityCaseDetail(
                            item,
                            widget.activityPackageId,
                            false,
                            activityTaskId: activityTaskId,
                          ),
                        ));
                      },
                      child: Row(
                        children: [
                          Text(
                            "??????????????????",
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xff888888),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Image.asset("assets/images/right.png"),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          canEdit
              ? Container(
                  margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(25, 5, 0, 20),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 0.5,
                        color: borderColor,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      var taskId =
                          await Navigator.of(context).push(MaterialPageRoute(
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
                      decoration:
                          DashedDecoration(dashedColor: Color(0xff9BCDF4)),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff489DFE),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 10,
                  margin: EdgeInsets.only(left: 25),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 0.5,
                        color: borderColor,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildGroupItem(int resourceID, ActivityQuestionnairesGroup item,
      bool isLast, bool isFirst) {
    var borderColor = Color(0xffaaaaaa);
    var textColor = Color(0xff888888);
    var groupFinished = false;
    if (item.status == "COMPLETE" || item.status == "PASS") {
      borderColor = Color(0xff52C41A);
      textColor = Color(0xff52C41A);
      groupFinished = true;
    } else if (item.status == "PROCEEDING") {
      textColor = Color(0xff107bfd);
    }
    List<Widget> sources = [];
    bool isExpanded = expandedGroup.contains(item.groupId);
    if (isExpanded) {
      for (int i = 0; i < item.questionnaires.length; i++) {
        var one = item.questionnaires[i];
        var cell = buildPlanItem(
          resourceID,
          one,
          isLast,
          i == 0 && isFirst,
          isGroup: true,
          groupFinished: groupFinished,
          groupId: item.groupId,
        );
        sources.add(cell);
      }
    } else {
      var container = Container(
        height: 10,
        margin: EdgeInsets.only(left: 25),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: borderColor,
                  ),
                ),
              ),
      );
      sources.add(container);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (expandedGroup.contains(item.groupId)) {
            expandedGroup.remove(item.groupId);
          } else {
            expandedGroup.add(item.groupId);
          }
        });
      },
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          height: 21,
                          child: Text(
                            "${item.schedule}%",
                            style: TextStyle(
                              fontSize: 14,
                              color: borderColor,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "${item.groupName}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ),
                        Text(
                          "???${item.completeNum}/${item.totalNum}??????",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  isExpanded
                      ? Image.asset("assets/images/up.png")
                      : Image.asset("assets/images/down.png"),
                  // Icon(
                  //     isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
            ...sources,
            Padding(padding: EdgeInsets.only(bottom: 5)),
          ],
        ),
      ),
    );
  }

  Widget buildPlanItem(int resourceID, ActivityQuestionnairesSubEntity item,
      bool isEnd, bool isFirst,
      {bool isGroup = false, bool groupFinished = false, int groupId}) {
    ActivityQuestionnaireEntity data = _data;
    var timeText = "";
    var img = "assets/images/not_open.png";
    var statusText = "?????????";
    var statusColor = Color(0xffDEDEE1);
    var borderColor = Color(0xffaaaaaa);
    if (item.status == "COMPLETE" || item.status == "WAIT_VERIFY") {
      timeText = "${slashNormalDateFormate(item.submitTime)}??????";
      statusText = "?????????";
      statusColor = Color(0xff52C41A);
      borderColor = Color(0xff52C41A);
      img = "assets/images/complete.png";
    } else {
      if (item.status == "PROCEEDING" || item.status == "REJECT") {
        statusText = "?????????";
        statusColor = Color(0xff489DFE);
        borderColor = Color(0xffaaaaaa);
        img = "assets/images/progress.png";
      } else {
        statusText = "?????????";
        statusColor = Color(0xffDEDEE1);
        borderColor = Color(0xffaaaaaa);
        img = "assets/images/not_open.png";
      }
      var now = DateTime.now().millisecondsSinceEpoch;
      if (item.openTime != null && now < item.openTime) {
        if (!isFirst) {
          timeText = "${slashNormalDateFormate(item.openTime)}??????";
        }
      } else if (item.endTime != null) {
        timeText = "${slashNormalDateFormate(item.endTime)}??????";
      }
      if (item.expire) {
        statusText = "?????????";
        statusColor = Color(0xffDEDEE1);
        borderColor = Color(0xffaaaaaa);
        img = "assets/images/expire.png";
      }
    }
    if (isGroup && groupFinished) {
      borderColor = Color(0xff52C41A);
    }

    var statusWidget = Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 7),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          Image.asset(img),
          Padding(padding: EdgeInsets.only(right: 4)),
          Text(
            statusText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
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
            ],
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
              "????????????:${item.rejectReason}",
              style: TextStyle(
                color: Color(0xffFECE35),
                fontSize: 12,
              ),
            ),
          ),
        content,
      ],
    );
    var paddingContainer = (Widget child, {double bottom = 20}) {
      return Container(
        margin: EdgeInsets.fromLTRB(25, 0, 0, 0),
        padding: EdgeInsets.fromLTRB(25, 5, 0, bottom),
        decoration: isEnd
            ? null
            : BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 0.5,
                    color: borderColor,
                  ),
                ),
              ),
        child: child,
      );
    };
    Widget head;
    if (isGroup) {
      head = paddingContainer(
        Row(
          children: [
            Text(
              "??????${item.sort}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            statusWidget,
            if (item.allowShare ?? false)
              Row(
                children: [
                  Container(width: 4,),
                  Image.asset(
                    "assets/images/share_arrow.png",
                    width: 12,
                    height: 12,
                  ),
                  Container(width: 4,),
                  Text("?????????",style: TextStyle(fontSize: 10,color: Color(0xff888888)),),
                ],
              ),
            Spacer(),
            Text(
              timeText,
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: 10,
              ),
            ),
          ],
        ),
        bottom: 0,
      );
    } else {
      head = Row(
        children: [
          Container(
            width: 50,
            alignment: Alignment.center,
            child: Text(
              "${item.schedule}%",
              style: TextStyle(
                fontSize: 14,
                color: borderColor,
              ),
            ),
          ),
          Text(
            "??????${item.sort}",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          statusWidget,
          if (item.allowShare ?? false)
            Row(
              children: [
                Container(width: 4,),
                Image.asset(
                  "assets/images/share_arrow.png",
                  width: 12,
                  height: 12,
                ),
                Container(width: 4,),
                Text("?????????",style: TextStyle(fontSize: 10,color: Color(0xff888888)),),
              ],
            ),
          Spacer(),
          Text(
            timeText,
            style: TextStyle(
              color: Color(0xff888888),
              fontSize: 10,
            ),
          ),
        ],
      );
    }
    var all = Container(
      margin: EdgeInsets.fromLTRB(0, 0, 25, 0),
      child: Column(
        children: [
          head,
          paddingContainer(bottom, bottom: isGroup ? 5 : 20),
        ],
      ),
    );
    return GestureDetector(
      onTap: debounce(() {
        if (disable &&
            (item.status == "PROCEEDING" || item.status == "NOT_OPEN")) {
          EasyLoading.showToast("???????????????????????????????????????");
          return;
        }
        if (status == "END" &&
            (item.status == "NOT_OPEN" || item.status == "PROCEEDING")) {
          EasyLoading.showToast("???????????????????????????????????????");
          return;
        }
        var url =
            "${UrlProvider.mHost(Environment.instance)}mpost/#/questionnaire?activityPackageId=${data.activityPackageId}&resourceId=$resourceID&questionnaireId=${item.questionnaireId}&sort=${item.sort}&type=market&packageStatus=${status}&activityTaskId=${activityTaskId}&groupId=$groupId";
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
        // ?????????????????????????????????
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
        title: Text("${activityName(activetyType)}??????"),
      ),
      body: buildContent(),
    );
  }
}
