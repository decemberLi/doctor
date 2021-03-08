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

class _ResearchDetailState extends State<ResearchDetail> {
  bool collapsed = true;

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

  Widget plans(LearnDetailItem data) {
    var template = data.resources.first;
    if (template == null || template.questionnaires == null) return Container();
    List<Widget> sources = [];
    for (int i = 0; i < template.questionnaires.length; i++) {
      var item = template.questionnaires[i];
      var cell = buildPlanItem(data, template.resourceId, item,
          i == template.questionnaires.length - 1);
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
                '执行学习计划',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF107BFD),
                ),
              ),
            ),
            buildCaseItem(template.illnessCase),
            ...sources,
            GestureDetector(
              onTap: () {
                EasyLoading.instance.flash(() async {
                  await API.shared.server.learnSubmit(
                    {
                      'learnPlanId': data.learnPlanId,
                    },
                  );
                  EasyLoading.showToast('提交成功');
                });
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
                  color: Color(0xff489DFE).withOpacity(0.85),
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff489DFE).withOpacity(0.4),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.right,
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
    ));
  }

  Widget buildCaseItem(IllnessCase item) {
    var buttonText = "点击此处去编辑";
    var statusText = "待完成";
    var statusColor = Color(0xff489DFE);
    var borderColor = Color(0xff888888);
    if (item.status == "COMPLETE") {
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
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => CaseDetail(item),
                ));
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
      LearnDetailItem data, int resourceID, Questionnaires item, bool isEnd) {
    var statusText = "未开启";
    var statusColor = Color(0xffDEDEE1);
    var borderColor = Color(0xff888888);
    if (item.status == "PROCEEDING") {
      statusText = "待完成";
      statusColor = Color(0xff489DFE);
      borderColor = Color(0xff888888);
    }else if (item.status == "COMPLETE") {
      statusText = "已完成";
      statusColor = Color(0xff52C41A);
      borderColor = Color(0xff52C41A);
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
                item.title,
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
                "填写问卷",
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
        var url =
            "https://m-dev.e-medclouds.com/mpost/#/questionnaire?learnPlanId=${data.learnPlanId}&resourceId=$resourceID&questionnaireId=${item.questionnaireId}";
        MedcloudsNativeApi.instance().openWebPage(url);
        print("on tap");
      },
      child: all,
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
              plans(model.data),
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
