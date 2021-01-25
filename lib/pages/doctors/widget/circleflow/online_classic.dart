import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnlineClassicEntity {
  final int id;
  final String coverImgUrl;
  final String title;
  final int viewNum;

  OnlineClassicEntity(
    this.id,
    this.coverImgUrl,
    this.title,
    this.viewNum,
  );
}

class OnlineClassicWidget extends StatelessWidget {
  final List<OnlineClassicEntity> entities;

  OnlineClassicWidget(this.entities);

  header() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
            child: Row(
          children: [
            Image(
              image: AssetImage("assets/images/docrot_circle_head_icon.png"),
              width: 12,
              height: 12,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                "在线医课堂",
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeColor.colorFF222222,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        )),
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 20),
            child: Text(
              "查看全部",
              style: TextStyle(
                fontSize: 12,
                color: ThemeColor.colorFF489DFE,
              ),
            ),
          ),
          onTap: () {
            //TODO 跳转
          },
        )
      ],
    );
  }

  Widget buildItem(OnlineClassicEntity entity) {
    return GestureDetector(
      child: Container(
        width: 133,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: ThemeColor.colorFFBCBCBC),
              height: 80,
              width: 133,
              child: entity.coverImgUrl == null
                  ? Container()
                  : Image.network(
                entity.coverImgUrl,
                width: 133,
                height: 80,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "${entity.title}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeColor.colorFF222222,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                "${entity?.viewNum}次学习",
                style: TextStyle(
                  fontSize: 10,
                  color: ThemeColor.colorFF999999,
                ),
              ),
            )
          ],
        ),
      ),
      onTap: _goDetail,
    );
  }

  List<Widget> buildItems() {
    List<Widget> widgets = [];

    for (int i = 0; i < entities.length; i++) {
      widgets.add(buildItem(entities[i]));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, top: 12),
      height: 170,
      child: Column(
        children: [
          header(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 12),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (buildContext, index) {
                    if (index == entities.length - 1) {
                      return Row(
                        children: [
                          buildItem(entities[index]),
                          Container(
                            color: Colors.white,
                            width: 20,
                          )
                        ],
                      );
                    }
                    return buildItem(entities[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(color: Colors.white, width: 16);
                  },
                  itemCount: entities.length),
            ),
          )
        ],
      ),
    );
  }

  _goDetail() {
    // TODO 在线医课堂详情
  }
}
