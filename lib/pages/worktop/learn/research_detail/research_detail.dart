import 'package:doctor/pages/worktop/learn/learn_detail/constants.dart';
import 'package:doctor/pages/worktop/learn/model/learn_detail_model.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/learn/research_detail/case_detail.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/time_text.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:doctor/widgets/new_text_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_manager/api.dart';
import 'package:provider/provider.dart';
import 'package:doctor/widgets/YYYEasyLoading.dart';
import 'package:doctor/http/server.dart';

class ResearchDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResearchDetailState();
  }
}

class _ResearchDetailState extends State<ResearchDetail>
    with WidgetsBindingObserver {
  bool collapsed = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
    var model = Provider.of<LearnDetailViewModel>(context, listen: false);
    await model.initData();
    setState(() {});
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

  Widget message(LearnDetailItem data) {
    return item(
      Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${data.representName}推广员给您留言了：', //data.representName
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFFfece35),
                  ),
                ),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${data.reLearnReason}', //data.reLearnReason
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFFfece35),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget info(LearnDetailItem data) {
    List learnListFields = LEARN_LIST['DOCTOR_LECTURE'];
    List<Widget> infoList = [];
    Map dataMap = data.toJson();
    for (int i = 0; i < learnListFields.length; i++) {
      var fields = learnListFields[i];
      if (collapsed && fields['notCollapse'] == null) {
        continue;
      }
      var infoItem = _buildListItem(
          label: fields['label'],
          value: dataMap[fields['field']],
          format: fields['format'],
          needBorder: infoList.length != 0);
      infoList.add(infoItem);
    }
    return item(
      Column(
        children: [
          Container(
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        '学习计划信息',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF107BFD),
                        ),
                      ),
                      // LearnTextIcon(
                      //   text: "继续调研",
                      //   color: Color(0xffF6A419),
                      //   margin: EdgeInsets.only(left: 10),
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        collapsed
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: Color(0xFF107BFD),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  collapsed = !collapsed;
                });
              },
            ),
          ),
          ...infoList,
        ],
      ),
    );
  }

  Widget plans(LearnDetailViewModel model) {
    LearnDetailItem data = model.data;
    var template = data.resources.first;
    if (template == null || template.questionnaires == null) return Container();
    List<Widget> sources = [];
    var canUp = false;
    for (int i = 0; i < template.questionnaires.length; i++) {
      var item = template.questionnaires[i];
      var cell = buildPlanItem(model, template.resourceId, item,
          i == template.questionnaires.length - 1);
      sources.add(cell);
      canUp = canUp || item.status == "COMPLETE";
    }
    var upColor = Color(0xFFBCBCBC);
    var shadowColor = Color(0xFFBCBCBC).withOpacity(0.4);
    if (canUp) {
      upColor = Color(0xff107BFD);
      shadowColor = Color(0xff489DFE).withOpacity(0.4);
    }
    var submit = () {
      EasyLoading.instance.flash(
        () async {
          await API.shared.server.learnSubmit(
            {
              'learnPlanId': data.learnPlanId,
            },
          );
          EasyLoading.showSuccess("提交成功");
          Future.delayed(
            Duration(seconds: 1),
            () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    };
    var showAlert = (int index) {
      showCupertinoDialog<bool>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Container(
              padding: EdgeInsets.only(top: 12),
              child: Text("您还未完成问卷$index,\n确定提交吗？"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "取消",
                  style: TextStyle(
                    color: ThemeColor.primaryColor,
                  ),
                ),
                onPressed: () async{
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "提交",
                  style: TextStyle(
                    color: ThemeColor.primaryColor,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  submit();
                },
              ),
            ],
          );
        },
      );
    };
    var showSubmit = (data.status != "SUBMIT_LEARN" && data.status != "ACCEPTED");
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
                '执行学习计划',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF107BFD),
                ),
              ),
            ),
            buildCaseItem(model, template.illnessCase),
            ...sources,
            if (showSubmit)
            GestureDetector(
              onTap: () {
                var first = template.questionnaires.first;
                if (first.status != 'COMPLETE') {
                  return;
                }
                for (int i = 1; i < template.questionnaires.length; i++) {
                  var item = template.questionnaires[i];
                  if (item.status != "COMPLETE") {
                    showAlert(item.sort);
                    return;
                  }
                }
                submit();
              },
              child: Container(
                width: double.infinity,
                height: 44,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(25, 5, 25, 10),
                child: Text(
                  "提交学习计划",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: upColor,
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
      {String label, dynamic value, Function format, bool needBorder = false}) {
    return Container(
      child: Column(
        children: [
          needBorder
              ? Container(
                  height: 20,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 1,
                    color: Color(0xFFF3F5F8),
                  ),
                )
              : Container(
                  height: 16,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Color(0xff444444),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCaseItem(LearnDetailViewModel model, IllnessCase item) {
    var buttonText = "点击此处去填写";
    var statusText = "待完成";
    var statusColor = Color(0xff489DFE);
    var borderColor = Color(0xff888888);
    LearnDetailItem data = model.data;
    var isHistory = data.status == "SUBMIT_LEARN" || data.status == "ACCEPTED";
    if (isHistory) {
      buttonText = "查看病例信息";
      statusText = "已完成";
      statusColor = Color(0xff52C41A);
      borderColor = Color(0xff52C41A);
    }else if (item.status == "COMPLETE") {
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
              // Expanded(child: Container()),
              // Text(
              //   "12月11日完成",
              //   style: TextStyle(
              //     color: Color(0xff888888),
              //     fontSize: 10,
              //   ),
              // ),
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
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => CaseDetail(item,!isHistory),
                ));
                await model.initData();
                setState(() {});
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

  Widget buildPlanItem(LearnDetailViewModel model, int resourceID,
      Questionnaires item, bool isEnd) {
    LearnDetailItem data = model.data;
    var statusText = "未开启";
    var statusColor = Color(0xffDEDEE1);
    var borderColor = Color(0xff888888);
    if (item.status == "PROCEEDING") {
      statusText = "待完成";
      statusColor = Color(0xff489DFE);
      borderColor = Color(0xff888888);
    } else if (item.status == "COMPLETE") {
      statusText = "已完成";
      statusColor = Color(0xff52C41A);
      borderColor = Color(0xff52C41A);
    }
    var statusWidget =Container();
    if (statusText == "已完成" || (data.status != "SUBMIT_LEARN" && data.status != "ACCEPTED")){
      statusWidget =  Container(
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
    }
    var timeText = "";
    if (item.completeTime != null) {
      timeText = "${RelativeDateFormat.format(item.completeTime)}完成";
    }

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
            child: content,
          ),
        ],
      ),
    );
    return GestureDetector(
      onTap: () {
        if (item.disable) {
          EasyLoading.showToast("问卷已下架，请联系管理员处理");
          return;
        }
        var url =
            "https://m-dev.e-medclouds.com/mpost/#/questionnaire?learnPlanId=${data.learnPlanId}&resourceId=$resourceID&questionnaireId=${item.questionnaireId}&sort=${item.sort}";
        MedcloudsNativeApi.instance().openWebPage(url);
        print("on tap $url");
      },
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

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<LearnDetailViewModel>(context, listen: true);
    var data = model.data;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("医学调研详情"),
      ),
      body: Container(
        color: Color(0xfff3f5f8),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (data.reLearnReason != null &&
                  data.status != 'SUBMIT_LEARN' &&
                  data.status != 'ACCEPTED')
                message(model.data),
              info(model.data),
              plans(model),
              Container(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
