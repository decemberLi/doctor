import 'package:doctor/theme/theme.dart';
import 'package:flutter/material.dart';

class OpenClassEntity {
  String title;
}

class EnterpriseOpenClassWidget extends StatelessWidget {
  final List<OpenClassEntity> entities;

  EnterpriseOpenClassWidget(this.entities);

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
            //TODO 跳转
          },
        )
      ],
    );
  }

  Widget buildItem(OpenClassEntity entity) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: AssetImage("assets/images/common_statck_bg.png"),
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台首个互联网医院平台…",
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
              "17亿次学习",
              style: TextStyle(
                fontSize: 10,
                color: ThemeColor.colorFF999999,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, top: 12, right: 20),
      child: Column(
        children: [
          header(),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(child: buildItem(null)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(child: buildItem(null)),
                Container(
                  width: 20,
                  color: Colors.white,
                ),
                Expanded(child: buildItem(null)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
