import 'dart:convert';

import 'package:doctor/common/event/event_tab_index.dart';
import 'package:doctor/root_widget.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryEntity {
  final String type;
  final String iconUrl;
  final String text;
  final String code;

  CategoryEntity(this.type, this.iconUrl, this.text, this.code);
}

class CategoryWidget extends StatelessWidget {
  final List<CategoryEntity> entities;

  CategoryWidget(this.entities);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: buildWidgets(context),
      ),
    );
  }

  List<Widget> buildWidgets(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < entities.length; i++) {
      list.add(buildItem(context, entities[i], isFirst: i == 0));
    }
    return list;
  }

  buildItem(BuildContext context, CategoryEntity each, {bool isFirst = false}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: isFirst ? 0 : 32),
        child: Column(
          children: [
            Image.network(
              each.iconUrl,
              width: 54,
              height: 54,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                      color: Color(0xffEAF3FF),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  height: 54,
                  width: 54,
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Text(
                each.text,
                style: TextStyle(fontSize: 12, color: ThemeColor.colorFF222222),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        eventBus.fire(EventVideoPause());
        Navigator.pushNamed(context, RouteManagerOld.DOCTOR_LIST1, arguments: jsonEncode({
          'title': each.text,
          'code': each.code,
        }));
      },
    );
  }
}
