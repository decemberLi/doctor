import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/pages/activity/widget/activity_widget.dart';
import 'package:doctor/widgets/table_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor/http/activity.dart';
import 'package:http_manager/api.dart';
import 'package:yyy_route_annotation/yyy_route_annotation.dart';
@RoutePage()
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
            child: ActivityWidget(entity),
          );
        },
        getData: (page) async{
          var list = await API.shared.activity.packageList(page);
          print(list);
          var result = list['records']
              .map<ActivityEntity>((item) => ActivityEntity(item))
              .toList();
          return Future.value(result);
        },
      ),
    );
  }
}
