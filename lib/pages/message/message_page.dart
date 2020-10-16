import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'common_style.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Widget MessageItem(String lable, String img, int msgCount, callBack) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context)),
      ),
      child: ListTile(
        title: Text(
          lable,
          style: fontStyle,
        ),
        leading: Image.asset(
          img,
          width: 24,
          height: 24,
        ),
        trailing: Stack(
          overflow: Overflow.visible,
          children: [
            Icon(Icons.keyboard_arrow_right),
            Positioned(
                left: -25,
                child: Container(
                  // padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  constraints: BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  child: Center(
                      child: Text(
                    msgCount > 99 ? '99+' : '$msgCount',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )),
                ))
          ],
        ),
        onTap: () {
          callBack();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息中心'),
        elevation: 0,
      ),
      body: Container(
          color: ThemeColor.colorFFF3F5F8,
          child: Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              children: [
                MessageItem('公告', 'assets/images/learn.png', 10, () {
                  print('公告');
                  // TODO: 跳转公告页面
                }),
                MessageItem('学习计划', 'assets/images/learn.png', 11, () {
                  print('学习计划');
                  // TODO: 跳转学习计划页面
                }),
                MessageItem('患者处方', 'assets/images/learn.png', 100, () {
                  print('患者处方');
                  // TODO: 跳转患者处方页面
                }),
              ],
            ),
          )),
    );
  }
}
