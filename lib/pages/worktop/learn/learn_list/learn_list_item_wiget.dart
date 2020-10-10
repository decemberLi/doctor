import 'package:doctor/pages/worktop/learn/model/learn_list_model.dart';
import 'package:doctor/utils/constants.dart';
import 'package:flutter/material.dart';

class ResourceTypeListWiget extends StatelessWidget {
  final List<ResourceTypeResult> resourceTypeList;
  ResourceTypeListWiget(this.resourceTypeList);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: resourceTypeList
            .map((e) => Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFDEDEE1),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  padding: EdgeInsets.only(left: 4, right: 4),
                  margin: EdgeInsets.only(right: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        MAP_RESOURCE_TYPE[e.resourceType],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

/// 学习计划列表项
class LearnListItemWiget extends StatelessWidget {
  final LearnListItem item;
  LearnListItemWiget(this.item);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              TASK_TEMPLATE[item.taskTemplate],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ResourceTypeListWiget(item.resourceTypeResult)
        ],
      ),
    );
  }
}
