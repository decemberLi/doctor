import 'package:doctor/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:doctor/common/env/environment.dart';
import 'package:doctor/common/env/url_provider.dart';
import 'package:doctor/pages/worktop/learn/model/learn_detail_model.dart';
import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/pages/worktop/learn/research_detail/case_detail.dart';
import 'package:doctor/pages/worktop/learn/view_model/learn_view_model.dart';
import 'package:doctor/utils/MedcloudsNativeApi.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/time_text.dart';
import 'package:doctor/widgets/dashed_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ActivityResearch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActivityResearch();
  }
}

class _ActivityResearch extends State<ActivityResearch> with WidgetsBindingObserver {

  bool collapsed = true;
  LearnDetailViewModel _model = LearnDetailViewModel(137574);

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
            buildCaseItem(model, template.illnessCase),
            ...sources,
          ],
        ),
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
            "${UrlProvider.mHost(Environment.instance)}mpost/#/questionnaire?learnPlanId=${data.learnPlanId}&resourceId=$resourceID&questionnaireId=${item.questionnaireId}&sort=${item.sort}";
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

  Widget card({@required Widget child}) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.only(left: 16, right: 16, top: 12,bottom: 64),
      padding: EdgeInsets.symmetric(vertical: 21, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F5F8),
      appBar: AppBar(
        title: Text("医学调研详情"),
      ),
      body: ProviderWidget<LearnDetailViewModel>(
        model: _model,
        onModelReady: (model) => model.initData(),
        builder: (context, model, child) {
          var data = model.data;
          if (data == null){
            return Container();
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                if (data.reLearnReason != null &&
                    data.status != 'SUBMIT_LEARN' &&
                    data.status != 'ACCEPTED')
                  message(model.data),
                plans(model),
                Container(
                  height: 20,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
