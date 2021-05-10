import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_manager/api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:doctor/http/activity.dart';

import 'activity_constants.dart';

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
  ActivityDetailEntity _data;
  List _list;
  bool _isLoading = true;
  String _error;

  void firstGetData() async {
    setState(() {
      _isLoading = true;
    });
    var result =
        await API.shared.activity.packageDetail(widget.activityPackageId);
    _data = ActivityDetailEntity();
    var list =
        await API.shared.activity.activityTaskList(widget.activityPackageId, 1);
    _list = list;
    setState(() {
      _isLoading = false;
    });
  }

  void loadMoreData() async {
    List list =
        await API.shared.activity.activityTaskList(widget.activityPackageId, 1);
    _refreshController.loadComplete();
    _list.addAll(list);
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
          line("截止日期", "${_data.endTime}"),
        ];
      }
      return [];
    }

    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cardTitle("病例征集信息"),
              Expanded(child: Container()),
              IconButton(
                icon: showInfo
                    ? Icon(Icons.arrow_drop_down)
                    : Icon(Icons.arrow_drop_up),
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
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              cardTitle("病例征集说明"),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 12),
          ),
          Text(
            _data.activityContent,
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
    Widget line(String desc, String status) {
      Color color = Color(0xff444444);
      if (status == "审核未通过") {
        color = Color(0xffFAAD14);
      } else if (status == "审核通过") {
        color = Color(0xff52C41A);
      }
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Color(0xffe5e5f5),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Text(
              desc,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff444444),
              ),
            ),
            Expanded(child: Container()),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> lines = [];
    for (int i = 0; i < _list.length; i++) {
      var item = _list[i];
      String desc = "";
      if (widget.type == TYPE_CASE_COLLECTION) {
        desc = "${item["activityTaskName"]}:已上传${item["pictureNum"]}张图片";
      } else {
        Map<String, dynamic> illnessCase = item["illnessCase"];
        desc =
            "${item["activityTaskName"]}:${illnessCase["sex"]}|${illnessCase["age"]}|${illnessCase["patientName"]}";
      }
      var itemWidget = line(desc, activityStatus(item["status"]));
      lines.add(itemWidget);
    }

    return card(
      child: Column(
        children: [
          Row(
            children: [
              cardTitle("病例列表"),
            ],
          ),
          ...lines,
        ],
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: SmartRefresher(
            controller: _refreshController,
            header: ClassicHeader(),
            footer: ClassicFooter(),
            enablePullDown: false,
            enablePullUp: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildInfo(),
                  buildDesc(),
                  buildList(),
                ],
              ),
            ),
            onLoading: () async {
              await Future.delayed(Duration(seconds: 2));
              _refreshController.loadComplete();
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "剩余调研数${_data.waitExecuteTask}",
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
            text: "填写病例信息",
            onPressed: (){

            },
          ),
        )
      ],
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
  Widget realBody(){
    if (_isLoading){
      return loading();
    }else if (_error != null){
      return _showHolder();
    }else {
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
      body: realBody(),
    );
  }
}