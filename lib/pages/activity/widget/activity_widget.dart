import 'package:doctor/pages/activity/activity_constants.dart';
import 'package:doctor/pages/activity/entity/activity_entity.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';


class ActivityWidget extends StatelessWidget {

  final ActivityEntity _data;

  ActivityWidget(this._data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(activityName(_data.activityType), style: TextStyle(
                  fontSize: 12, color: ThemeColor.colorFF000000)),

            ],
          )
        ],
      ),
    );
  }
}
