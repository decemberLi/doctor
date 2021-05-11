import 'package:doctor/pages/activity/activity_case_detail.dart';
import 'package:doctor/pages/activity/activity_research.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/pages/activity/widget/activity_resource_detail.dart';
import 'package:doctor/provider/view_state_widget.dart';
import 'package:doctor/utils/data_format_util.dart';
import 'package:doctor/utils/time_text.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  List _list = [];
  bool _isLoading = true;
  String _error;
  int _page = 1;

  @override
  void initState() {
    firstGetData();
    super.initState();
  }

  void firstGetData() async {
    try {
      var result =
          await API.shared.activity.packageDetail(widget.activityPackageId);


      _data = ActivityDetailEntity(result);
      var rawData = await API.shared.activity
          .activityTaskList(widget.activityPackageId, 1);
      var list = rawData["records"];
      var allPage = rawData["pages"] as int;
      if (allPage == _page){
        _refreshController.loadNoData();
      }
      _list = list;
      _page = 1;
    } catch (e,stack) {
      setState(() {
        _error = "${e}";
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void loadMoreData() async {
    _page ++;
    var rawData =
        await API.shared.activity.activityTaskList(widget.activityPackageId, _page);
    List list = rawData["records"];
    var allPage = rawData["pages"] as int;
    print("all page is - $allPage");
    if (allPage == _page){
      _refreshController.loadNoData();
    }else{
      _refreshController.loadComplete();
    }
    setState(() {
      _list.addAll(list);
    });
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
          line("截止日期", "${normalDateFormate(_data.endTime)}"),
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
              cardTitle("${activityName(widget.type)}信息"),
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
    if (_data.activityContent == null ){
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
    Widget line(String desc, String status, int schedule, int taskId) {
      Color color = Color(0xff444444);
      String text = "";
      print("$status --  status is ");
      if (schedule != null && schedule < 100) {
        text = "$schedule%";
      } else if (status == "WAIT_VERIFY") {
        text = "审核中";
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
        onTap: () {
          if (_data.activityType == TYPE_CASE_COLLECTION) {
            Navigator.of(context).push(MaterialPageRoute(builder: (c) {
              return ActivityResourceDetailPage(_data.activityPackageId, taskId,
                  status: status);
            }));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (c) {
              return ActivityResearch(
                _data.activityPackageId,
                _data.status,
                activityTaskId: taskId,
              );
            }));
          }
        },
      );
    }

    List<Widget> lines = [];
    for (int i = 0; i < _list.length; i++) {
      var item = _list[i];
      String desc = "";
      if (widget.type == TYPE_CASE_COLLECTION) {
        desc = "病例${i+1}:已上传${item["pictureNum"]}张图片";
      } else {
        Map<String, dynamic> illnessCase = item["illnessCase"];
        desc = "病例${i+1}:";
        var needLine = false;
        if(illnessCase["sex"] != null){
          needLine = true;
          var name = "";
          if (illnessCase["sex"] == 0){
            name = "女";
            desc += "$name";
          }else if (illnessCase["sex"] == 1){
            name = "男";
            desc += "$name";
          }
        }

        if (illnessCase["age"] != null){
          if (needLine){
            desc += "|";
          }
          desc += "${illnessCase["age"]}";
          needLine = true;
        }

        if(illnessCase["patientName"] != null){
          if (needLine){
            desc += "|";
          }
          desc += "${illnessCase["patientName"]}";
        }
      }
      var itemWidget =
          line(desc, item["status"], item["schedule"], item["activityTaskId"]);
      lines.add(itemWidget);
    }

    if (_list.length == 0) {
      return Container();
    }
    var title = "病例列表";
    if (_data.activityType == TYPE_CASE_COLLECTION){
      title = "调研列表";
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
    if (_data.status == "WAIT_START") {
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
            child: Text("活动于${normalDateFormate(_data.startTime)}开始",style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),),
          ),
        )
      ];
    } else if (_data.status == "EXECUTING") {
      bottoms = [
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
            onPressed: () async{
              if(_data.waitExecuteTask <= 0){
                EasyLoading.showToast("没有剩余调研数");
                return;
              }
              if (_data.activityType == TYPE_CASE_COLLECTION) {
                await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                  return ActivityResourceDetailPage(_data.activityPackageId,null);
                }));
              } else {
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ActivityResearch(_data.activityPackageId,_data.status);
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
            child: Text("活动已结束",style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),),
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
        ...bottoms,
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
        onWillPop: () async{
          firstGetData();
          return true;
        },
      ),
    );
  }
}
