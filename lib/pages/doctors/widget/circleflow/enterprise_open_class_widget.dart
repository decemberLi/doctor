import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

class OpenClassEntity {
  final int id;
  final String coverImgUrl;
  final String videoUrl;
  final String title;
  final int viewNum;
  final String author;

  OpenClassEntity(
    this.id,
    this.coverImgUrl,
    this.videoUrl,
    this.title,
    this.viewNum,
    this.author,
  );
}

class EnterpriseOpenClassWidget extends StatelessWidget {
  final List<OpenClassEntity> entities;

  EnterpriseOpenClassWidget(this.entities);

  header(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Image(
                image: AssetImage("assets/images/doctor_circle_head_icon.png"),
                width: 12,
                height: 12,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "企业公开课",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColor.colorFF222222,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          child: Container(
            child: Text(
              "查看全部",
              style: TextStyle(
                fontSize: 12,
                color: ThemeColor.colorFF489DFE,
              ),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, RouteManager.DOCTOR_LIST2,
                arguments: 'OPEN_CLASS');
          },
        )
      ],
    );
  }

  Widget buildItem(BuildContext context, OpenClassEntity entity) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: ThemeColor.colorFFBCBCBC),
            height: 102,
            width: double.infinity,
            child: entity.coverImgUrl == null
                ? Container()
                : Image.network(
                    entity.coverImgUrl,
                    width: double.infinity,
                    height: 102,
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
              "${entity.viewNum}次学习",
              style: TextStyle(
                fontSize: 10,
                color: ThemeColor.colorFF999999,
              ),
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteManager.DOCTORS_ARTICLE_DETAIL,
            arguments: {
              'postId': entity?.id,
              'from': 'list',
              'type': 'OPEN_CLASS'
            });
      },
    );
  }

  Widget buildVideoPreviewItem(BuildContext context, OpenClassEntity entity) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: ThemeColor.colorFFBCBCBC),
            height: 210,
            width: double.infinity,
            child: entity.coverImgUrl == null
                ? Container()
                : Image.network(
                    entity.coverImgUrl,
                    width: double.infinity,
                    height: 210,
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              entity.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: ThemeColor.colorFF222222,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(
                  "${entity.author ?? ''}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeColor.colorFF222222,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                Text(
                  "${entity.viewNum ?? ''}次学习",
                  style: TextStyle(
                    fontSize: 10,
                    color: ThemeColor.colorFF999999,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteManager.DOCTORS_ARTICLE_DETAIL,
            arguments: {
              'postId': entity?.id,
              'from': 'list',
              'type': 'OPEN_CLASS'
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, top: 12, right: 20, bottom: 12),
      child: Column(
        children: [
          header(context),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(child: buildVideoPreviewItem(context, entities[0])),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(child: buildItem(context, entities[1])),
                Container(
                  width: 20,
                  color: Colors.white,
                ),
                Expanded(child: buildItem(context, entities[2])),
              ],
            ),
          )
        ],
      ),
    );
  }
}
