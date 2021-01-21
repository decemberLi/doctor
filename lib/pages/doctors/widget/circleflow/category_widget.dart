import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryEntity {
  final String type;
  final String iconUrl;
  final String text;

  CategoryEntity(this.type, this.iconUrl, this.text);
}

class CategoryWidget extends StatelessWidget {
  final List<CategoryEntity> entities;

  CategoryWidget(this.entities);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: buildWidgets(),
      ),
    );
  }

  List<Widget> buildWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < entities.length; i++) {
      list.add(buildItem(entities[i], isFirst: i == 0));
    }
    return list;
  }

  buildItem(CategoryEntity each, {bool isFirst = false}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: isFirst ? 0 : 32),
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/images/icon_like.png"),
              width: 54,
              height: 54,
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
        // TODO 跳转
      },
    );
  }
}
