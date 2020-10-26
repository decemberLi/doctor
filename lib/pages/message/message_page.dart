import 'dart:async';

import 'package:doctor/pages/message/view_model/message_center_view_model.dart';
import 'package:doctor/route/route_manager.dart';
import 'package:doctor/theme/theme.dart';
import 'package:doctor/widgets/ace_button.dart';
import 'package:flutter/material.dart';
import 'common_style.dart';
import 'message_list_page.dart';
import 'model/message_center_entity.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  MessageCenterModel _model = MessageCenterModel();

  @override
  void initState() {
    super.initState();
    _model.queryMessageCount();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Widget messageItem(String lable, String img, int msgCount, callBack,
      {Color dotColor = Colors.red}) {
    return Container(
      margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
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
                    color: dotColor,
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
              ),
            ),
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
      backgroundColor: ThemeColor.colorFFF3F5F8,
      appBar: AppBar(
        title: Text('消息中心'),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _model.stream,
        builder: (BuildContext context,
            AsyncSnapshot<MessageCenterEntity> snapshot) {
          Color dotColor =
              snapshot?.data ?? 0 == 0 ? Colors.transparent : Colors.red;
          return Container(
            padding: EdgeInsets.only(bottom: 5),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                messageItem('系统通知', 'assets/images/msg_system_notice.png',
                    snapshot?.data?.systemCount ?? 0, () {
                  goMessageList(MessageType.TYPE_SYSTEM);
                }, dotColor: dotColor),
                messageItem('学习计划', 'assets/images/msg_learn_plan.png',
                    snapshot?.data?.leanPlanCount ?? 0, () {
                  goMessageList(MessageType.TYPE_LEAN_PLAN);
                }, dotColor: dotColor),
                messageItem('患者处方', 'assets/images/msg_interact.png',
                    snapshot?.data?.prescriptionCount ?? 0, () {
                  goMessageList(MessageType.TYPE_PRESCRIPTION);
                }, dotColor: dotColor),
                messageItem('互动消息', 'assets/images/msg_patient.png',
                    snapshot?.data?.interactiveCount ?? 0, () {
                  goMessageList(MessageType.TYPE_INTERACTIVE);
                }, dotColor: dotColor),
              ],
            ),
          );
        },
      ),
    );
  }

  goMessageList(String type) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MessageListPage(type)),
      );
}
