import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HotPostEntity {
  int id;
  String text;

  HotPostEntity(this.id, this.text);
}

class HotPostWidget extends StatelessWidget {
  final List<HotPostEntity> entities;

  HotPostWidget(this.entities);

  buildItem(BuildContext context, HotPostEntity entity) {
    return GestureDetector(
      child: Container(
        width: 188,
        height: 102,
        padding: EdgeInsets.only(left: 11, right: 11, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: ThemeColor.colorFFE8E8E8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AssetImage("assets/images/icon_ying_hao.png"),
              width: 14,
              height: 14,
            ),
            Container(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "${entity.text ?? ''}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeColor.colorFF444444,
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteManager.DOCTORS_ARTICLE_DETAIL,
            arguments: {
              'postId': entity?.id,
              'from': 'list',
              'type': 'VIDEO_ZONE'
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 120,
      padding: EdgeInsets.only(left: 20, top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/images/icon_fire.png"),
                width: 20,
                height: 20,
              ),
              Text(
                "热\n帖\n榜",
                style: TextStyle(
                    color: ThemeColor.colorFF222222,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 14),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (buildContext, index) {
                    if (index == entities.length - 1) {
                      return Row(
                        children: [
                          buildItem(context, entities[index]),
                          Container(
                            color: Colors.white,
                            width: 20,
                          )
                        ],
                      );
                    }
                    return buildItem(context, entities[index]);
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
}
