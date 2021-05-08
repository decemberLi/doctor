import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/pages/activity/widget/activity_widget.dart';
import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends State<ActivityListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F8),
      appBar: AppBar(
        title: Text('活动列表'),
        elevation: 0,
      ),
      body: NormalTableView<ActivityEntity>(
        itemBuilder: (BuildContext context, dynamic entity) {
          return Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: ActivityWidget(entity, true),
          );
        },
        getData: (page) {
          List<ActivityEntity> list = [];
          list.add(ActivityEntity()
            ..activityType = TYPE_CASE_COLLECTION
            ..status = STATUS_WAIT
            ..activityName = '靖江宾馆冠心病相关问题讨论'
            ..companyName = '重庆易药云科技有限公司'
            ..endTime = DateTime.now().millisecondsSinceEpoch
            ..schedule = 70);
          list.add(ActivityEntity()
            ..activityType = TYPE_MEDICAL_SURVEY
            ..status = STATUS_EXECUTING
            ..activityName = '靖江宾馆冠心病相关问题讨论'
            ..companyName = '重庆易药云科技有限公司'
            ..endTime = DateTime.now().millisecondsSinceEpoch
            ..schedule = 10);
          list.add(ActivityEntity()
            ..activityType = TYPE_CASE_COLLECTION
            ..status = STATUS_FINISH
            ..activityName = '靖江宾馆冠心病相关问题讨论'
            ..companyName = '重庆易药云科技有限公司'
            ..endTime = DateTime.now().millisecondsSinceEpoch
            ..schedule = 70);
          return Future.value(list);
        },
      ),
    );
  }
}
