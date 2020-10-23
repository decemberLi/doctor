import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Widget messageItem(String lable, String img, callBack) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context)),
      ),
      child: ListTile(
        title: Text(
          lable,
          style: TextStyle(
            color: ThemeColor.colorFF000000,
            fontSize: 14,
          ),
        ),
        leading: Image.asset(
          img,
          width: 24,
          height: 24,
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          callBack();
        },
      ),
    );
  }

  Widget boxItem(
    String img,
    int counts,
    String lable,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          img,
          width: 40,
          height: 40,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '$counts',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              lable,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF717171),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          elevation: 0,
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Container(
              // margin: EdgeInsets.fromLTRB(16, 285, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  messageItem('资质认证', 'assets/images/learn.png', () {
                    print('资质认证');
                    Navigator.pushNamed(context, RouteManager.QUALIFICATION_PAGE);
                  }),
                  messageItem('设置', 'assets/images/learn.png', () {
                    print('设置');
                    // TODO: 设置页面
                  }),
                  messageItem('关于我们', 'assets/images/learn.png', () {
                    Navigator.pushNamed(context, RouteManager.ABOUT_US);
                  }),
                ],
              ),
            ),
            Positioned(
              top: 192,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                width: 343,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    boxItem('assets/images/learn.png', 165, '我的收藏'),
                    VerticalDivider(),
                    boxItem('assets/images/learn.png', 165, '我的患者'),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
